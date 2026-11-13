$ErrorActionPreference = 'Stop'
$metadataPath = Join-Path $PSScriptRoot '.logs\servicios.json'
if (-not (Test-Path -LiteralPath $metadataPath)) { Write-Output 'No hay procesos registrados por el iniciador.'; exit 0 }
$parsedServices = ConvertFrom-Json -InputObject (Get-Content -LiteralPath $metadataPath -Raw)
$taskServices = @()
foreach ($entry in $parsedServices) {
    if ($null -ne $entry.id -and $entry.executable -and $entry.started_at) { $taskServices += $entry }
}
[array]::Reverse($taskServices)
$remainingServices = @()
foreach ($service in $taskServices) {
    $process = Get-Process -Id $service.id -ErrorAction SilentlyContinue
    if (-not $process) { continue }
    $sameStart = $process.StartTime.ToUniversalTime().Ticks -eq ([datetime]$service.started_at).ToUniversalTime().Ticks
    if ($process.Path -ne $service.executable -or -not $sameStart) {
        $remainingServices += $service
        Write-Warning "El PID de $($service.name) no coincide con su registro. No se detuvo."
        continue
    }
    if ($service.name -eq 'mongodb') {
        & (Join-Path $PSScriptRoot 'backend\.venv\Scripts\python.exe') (Join-Path $PSScriptRoot 'backend\detener_mongodb.py')
        if ($LASTEXITCODE -ne 0) { throw 'MongoDB no pudo detenerse ordenadamente. Consulta los registros.' }
        if (-not $process.WaitForExit(30000)) { throw 'MongoDB aún está cerrando; no reiniciar hasta que el proceso termine.' }
    } elseif ($service.name -eq 'backend' -and $service.stop_token -match '^[0-9a-f]{32}$') {
        $stopFile = Join-Path $PSScriptRoot ('.logs\api-stop-' + $service.stop_token)
        New-Item -ItemType File -Path $stopFile -Force | Out-Null
        if (-not $process.WaitForExit(20000)) { throw 'La API sigue cerrando. Consulta .logs/backend-error.log.' }
        if (Test-Path -LiteralPath $stopFile) { Remove-Item -LiteralPath $stopFile }
    } elseif ($service.name -eq 'frontend') {
        $process.Kill()
        if (-not $process.WaitForExit(10000)) { throw 'La interfaz sigue cerrando.' }
    } else {
        # Compatibilidad con el iniciador anterior de Uvicorn.
        & taskkill.exe /PID $service.id /T /F | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "No se pudo detener el proceso de $($service.name)." }
    }
}
ConvertTo-Json -InputObject @($remainingServices) -Depth 4 | Set-Content -LiteralPath $metadataPath -Encoding UTF8
if ($remainingServices.Count -gt 0) { throw 'Quedan registros cuya identidad no pudo verificarse. Revisa .logs/servicios.json.' }
Write-Output 'Procesos de la demo detenidos. Los resultados permanecen en data/mongodb.'
