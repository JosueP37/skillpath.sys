param(
    [string]$PythonExe = '', [switch]$ConPruebas, [switch]$Comprobar,
    [switch]$HerramientasLocales, [switch]$RecrearEntorno, [string]$CacheDir = ''
)
$ErrorActionPreference = 'Stop'
$taskRoot = $PSScriptRoot
Set-Location -LiteralPath $taskRoot
if (-not [Environment]::Is64BitOperatingSystem) { throw 'SkillPath requiere Windows de 64 bits.' }
. (Join-Path $taskRoot 'scripts\herramientas_windows.ps1')
$taskServicesPath = Join-Path $taskRoot '.logs\servicios.json'
if (-not $Comprobar -and (Test-Path -LiteralPath $taskServicesPath)) {
    $taskParsedServices = ConvertFrom-Json -InputObject (Get-Content -LiteralPath $taskServicesPath -Raw)
    foreach ($taskService in $taskParsedServices) {
        $taskProcess = Get-Process -Id $taskService.id -ErrorAction SilentlyContinue
        if ($taskProcess -and $taskProcess.Path -eq $taskService.executable -and $taskProcess.StartTime.ToUniversalTime().Ticks -eq ([datetime]$taskService.started_at).ToUniversalTime().Ticks) { throw 'Esta copia de SkillPath esta abierta. Ejecuta DETENER_DEMO.cmd antes de preparar de nuevo.' }
    }
}
$taskTranscript = $false
try {
    if (-not $Comprobar) {
        New-Item -ItemType Directory -Path (Join-Path $taskRoot '.logs') -Force | Out-Null
        Start-Transcript -LiteralPath (Join-Path $taskRoot ('.logs\instalacion-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.log')) | Out-Null
        $taskTranscript = $true
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
    Write-Host '[1/6] Comprobando Python y Node.js...'
    $taskNodePath = Join-Path $taskRoot '.tools\node\node-v22.23.4-win-x64\node.exe'
    if (-not (Test-Path -LiteralPath $taskNodePath)) {
        $taskNodeCommand = if (-not $HerramientasLocales) { Get-Command node.exe -ErrorAction SilentlyContinue }
        $taskNodePath = if ($taskNodeCommand) { $taskNodeCommand.Source } else { '' }
        if ($taskNodePath) {
            $taskVersionText = & $taskNodePath --version
            if ($LASTEXITCODE -ne 0 -or [version]($taskVersionText.Trim().TrimStart('v')) -lt [version]'22.12.0') { $taskNodePath = '' }
        }
        if (-not $taskNodePath) {
            if ($Comprobar) { throw 'Falta Node.js compatible. Abre INSTALAR_Y_ABRIR.cmd.' }
            $taskNodePath = Install-SkillPathNode -ProjectRoot $taskRoot -CacheDir $CacheDir
        }
    }
    $taskNpmPath = Join-Path (Split-Path -Parent $taskNodePath) 'npm.cmd'
    if (-not (Test-Path -LiteralPath $taskNpmPath)) { throw 'Falta npm.cmd junto a Node.js. Vuelve a preparar las herramientas.' }
    $env:PATH = (Split-Path -Parent $taskNodePath) + ';' + $env:PATH
    $taskNodeText = & $taskNodePath --version
    if (-not $PythonExe) {
        $taskLocalPython = Join-Path $taskRoot '.tools\python312\tools\python.exe'
        $taskUserPython = Join-Path $env:LOCALAPPDATA 'Programs\Python\Python312\python.exe'
        if (Test-Path -LiteralPath $taskLocalPython) { $PythonExe = $taskLocalPython }
        elseif (-not $HerramientasLocales -and (Test-Path -LiteralPath $taskUserPython)) { $PythonExe = $taskUserPython }
        elseif (-not $HerramientasLocales) {
            $taskLauncher = Get-Command py.exe -ErrorAction SilentlyContinue
            if ($taskLauncher) {
                try {
                    $taskCandidate = & $taskLauncher.Source -3.12 -c 'import sys; print(sys.executable)' 2>$null
                    if ($LASTEXITCODE -eq 0) { $PythonExe = $taskCandidate | Select-Object -Last 1 }
                } catch { $PythonExe = '' }
            }
        }
        if (-not $PythonExe) {
            if ($Comprobar) { throw 'Falta Python 3.12. Abre INSTALAR_Y_ABRIR.cmd.' }
            $PythonExe = Install-SkillPathPython -ProjectRoot $taskRoot -CacheDir $CacheDir
        }
    }
    if (-not (Test-Path -LiteralPath $PythonExe)) { throw 'No existe el ejecutable indicado de Python.' }
    & $PythonExe -c 'import sys; assert sys.version_info[:2] == (3,12); print(sys.version)'
    if ($LASTEXITCODE -ne 0) { throw 'Se requiere Python 3.12. Indica -PythonExe o prepara las herramientas locales.' }
    $taskVenvFolder = Join-Path $taskRoot 'backend\.venv'
    $taskVenv = Join-Path $taskVenvFolder 'Scripts\python.exe'
    if ($Comprobar) {
        if (-not (Test-Path -LiteralPath $taskVenv)) { throw 'Falta el entorno virtual. Abre INSTALAR_Y_ABRIR.cmd.' }
        & $taskVenv -c 'import sys, fastapi, pymongo, argon2, uvicorn; assert sys.version_info[:2] == (3,12)'
        if ($LASTEXITCODE -ne 0) { throw 'Entorno virtual invalido. Deten la demo y usa PREPARAR_EQUIPO.cmd -RecrearEntorno.' }
        if (-not (Test-Path -LiteralPath (Join-Path $taskRoot 'frontend\node_modules\vite\bin\vite.js'))) { throw 'Faltan las dependencias del frontend.' }
        if (-not (Test-Path -LiteralPath (Join-Path $taskRoot 'frontend\dist\index.html'))) { throw 'Falta compilar el frontend.' }
        $taskMongoMetadata = Join-Path $taskRoot '.tools\mongodb\origen.json'
        if (-not (Test-Path -LiteralPath $taskMongoMetadata)) { throw 'Falta preparar MongoDB portable.' }
        $taskMongo = Get-Content -LiteralPath $taskMongoMetadata -Raw | ConvertFrom-Json
        if ($taskMongo.version -ne '8.0.32' -or -not (Test-Path -LiteralPath (Join-Path $taskRoot $taskMongo.executable))) { throw 'MongoDB portable esta incompleto.' }
        Write-Output "Preparacion comprobada. Python 3.12; Node $taskNodeText; MongoDB 8.0.32; frontend compilado."
        exit 0
    }
    if ($RecrearEntorno -and (Test-Path -LiteralPath $taskVenvFolder)) {
        $taskResolvedVenv = [IO.Path]::GetFullPath($taskVenvFolder)
        if ($taskResolvedVenv -ne [IO.Path]::GetFullPath((Join-Path $taskRoot 'backend\.venv'))) { throw 'Ruta del entorno virtual no permitida.' }
        Move-Item -LiteralPath $taskResolvedVenv -Destination ($taskResolvedVenv + '-respaldo-' + [guid]::NewGuid().ToString('N'))
    }
    Write-Host '[2/6] Preparando el entorno virtual...'
    if (Test-Path -LiteralPath $taskVenvFolder) {
        if (-not (Test-Path -LiteralPath $taskVenv)) { throw 'Entorno incompleto. Usa PREPARAR_EQUIPO.cmd -RecrearEntorno.' }
        & $taskVenv -c 'import sys; assert sys.version_info[:2] == (3,12)'
        if ($LASTEXITCODE -ne 0) { throw 'Entorno copiado o invalido. Usa PREPARAR_EQUIPO.cmd -RecrearEntorno.' }
    } else {
        & $PythonExe -m venv $taskVenvFolder
        if ($LASTEXITCODE -ne 0) { throw 'No se pudo crear el entorno virtual.' }
    }
    $env:PIP_CACHE_DIR = Join-Path $taskRoot '.tools\cache\pip'
    $env:npm_config_cache = Join-Path $taskRoot '.tools\cache\npm'
    $env:PYTHONUTF8 = '1'
    Write-Host '[3/6] Instalando dependencias del backend...'
    $taskRequirements = if ($ConPruebas) { 'backend\requirements-dev.txt' } else { 'backend\requirements.txt' }
    & $taskVenv -m pip install --disable-pip-version-check -r (Join-Path $taskRoot $taskRequirements)
    if ($LASTEXITCODE -ne 0) { throw 'Fallo pip. Comprueba la conexion con PyPI y el registro en .logs.' }
    & $taskVenv -m pip check
    if ($LASTEXITCODE -ne 0) { throw 'Las dependencias Python no son compatibles entre si.' }
    Write-Host '[4/6] Instalando dependencias de la interfaz...'
    Push-Location -LiteralPath (Join-Path $taskRoot 'frontend')
    try {
        & $taskNpmPath ci --no-fund
        if ($LASTEXITCODE -ne 0) { throw 'Fallo npm ci. Comprueba conexion con npm y package-lock.json.' }
        Write-Host '[5/6] Compilando la interfaz...'
        & $taskNpmPath run build
        if ($LASTEXITCODE -ne 0) { throw 'El frontend no compilo. Revisa .logs.' }
    } finally { Pop-Location }
    Write-Host '[6/6] Preparando MongoDB portable (descarga inicial aproximada de 800 MB)...'
    $env:SKILLPATH_DOWNLOAD_CACHE = $CacheDir
    & $taskVenv (Join-Path $taskRoot 'analisis\preparar_mongodb.py')
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo preparar MongoDB. Comprueba conexion, espacio libre y checksum en .logs.' }
    Write-Output 'Preparacion completa. Abre INICIAR_DEMO.cmd si ya tienes cuentas; para una instalacion nueva usa INSTALAR_Y_ABRIR.cmd.'
} finally {
    if ($taskTranscript) { Stop-Transcript | Out-Null }
}
