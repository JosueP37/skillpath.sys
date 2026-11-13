$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot
$env:PYTHONUTF8 = '1'
$taskPythonCheck = Join-Path $projectRoot 'backend\.venv\Scripts\python.exe'
if (-not (Test-Path -LiteralPath $taskPythonCheck)) { throw 'Falta preparar Python. Consulta INSTALACION_OTRA_MAQUINA.md.' }
& $taskPythonCheck -c 'import fastapi, pymongo, argon2, uvicorn'
if ($LASTEXITCODE -ne 0) { throw 'El entorno Python no funciona. Ejecuta PREPARAR_EQUIPO.ps1; los entornos virtuales no se copian entre equipos.' }
$logDir = Join-Path $projectRoot '.logs'
$dataDir = Join-Path $projectRoot 'data\mongodb'
New-Item -ItemType Directory -Path $logDir,$dataDir -Force | Out-Null
$taskServices = @()

# Comprobar todas las herramientas antes de abrir el primer servicio.
$taskPortableNode = Join-Path $projectRoot '.tools\node\node-v22.23.4-win-x64\node.exe'
$nodePath = if (Test-Path -LiteralPath $taskPortableNode) { $taskPortableNode } else { (Get-Command node.exe -ErrorAction Stop).Source }
$taskViteCheck = Join-Path $projectRoot 'frontend\node_modules\vite\bin\vite.js'
if (-not (Test-Path -LiteralPath $taskViteCheck)) { throw 'Falta la interfaz. Ejecuta INSTALAR_Y_ABRIR.cmd.' }
if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'frontend\dist\index.html'))) { throw 'Falta compilar la interfaz. Ejecuta PREPARAR_EQUIPO.cmd.' }
$servicesPath = Join-Path $logDir 'servicios.json'
$taskPreviousServices = @()
if (Test-Path -LiteralPath $servicesPath) {
    $taskParsedServices = ConvertFrom-Json -InputObject (Get-Content -LiteralPath $servicesPath -Raw)
    foreach ($taskEntry in $taskParsedServices) {
        if ($null -ne $taskEntry.id -and $taskEntry.executable -and $taskEntry.started_at) {
            $taskRegistered = Get-Process -Id $taskEntry.id -ErrorAction SilentlyContinue
            if ($taskRegistered -and $taskRegistered.Path -eq $taskEntry.executable -and $taskRegistered.StartTime.ToUniversalTime().Ticks -eq ([datetime]$taskEntry.started_at).ToUniversalTime().Ticks) { $taskPreviousServices += $taskEntry }
        }
    }
}

function Test-TaskPort([int] $port) {
    $client = [System.Net.Sockets.TcpClient]::new()
    try { $client.Connect('127.0.0.1', $port); return $true }
    catch { return $false }
    finally { $client.Dispose() }
}

$taskApiPort = 8000
$taskPreviousApi = $taskPreviousServices | Where-Object { $_.name -eq 'backend' } | Select-Object -First 1
if ($taskPreviousApi) {
    # Los registros de las versiones anteriores corresponden al puerto 8000.
    if ($taskPreviousApi.port -in @(8000, 8001)) { $taskApiPort = [int]$taskPreviousApi.port }
} elseif (Test-TaskPort 8000) {
    if (Test-TaskPort 8001) { throw 'Los puertos 8000 y 8001 estan ocupados. Libera uno para iniciar SkillPath.' }
    $taskApiPort = 8001
    Write-Output 'El puerto 8000 esta ocupado. SkillPath usara el puerto 8001 para su API.'
}
$env:SKILLPATH_API_PORT = [string]$taskApiPort

foreach ($taskEndpoint in @(@{name='mongodb';port=27018}, @{name='backend';port=$taskApiPort}, @{name='frontend';port=5173})) {
    if (Test-TaskPort $taskEndpoint.port) {
        $taskOwned = $false
        foreach ($taskEntry in $taskPreviousServices) {
            if ($taskEntry.name -ne $taskEndpoint.name) { continue }
            $taskProcess = Get-Process -Id $taskEntry.id -ErrorAction SilentlyContinue
            if ($taskProcess -and $taskProcess.Path -eq $taskEntry.executable -and $taskProcess.StartTime.ToUniversalTime().Ticks -eq ([datetime]$taskEntry.started_at).ToUniversalTime().Ticks) { $taskOwned = $true }
        }
        if (-not $taskOwned) { throw "El puerto $($taskEndpoint.port) esta ocupado por un servicio no registrado en esta copia. Cierra ese servicio o la otra copia de SkillPath antes de iniciar." }
    }
}

function Save-TaskServices {
    ConvertTo-Json -InputObject @($taskPreviousServices + $taskServices) -Depth 4 | Set-Content -LiteralPath $servicesPath -Encoding UTF8
}

if (-not (Test-TaskPort 27018)) {
    $metadataPath = Join-Path $projectRoot '.tools\mongodb\origen.json'
    if (-not (Test-Path -LiteralPath $metadataPath)) { throw 'Falta MongoDB portable. Consulta README.md para preparar el entorno.' }
    $taskMongoMetadata = Get-Content -LiteralPath $metadataPath -Raw | ConvertFrom-Json
    $taskMongoDirectory = Join-Path $projectRoot '.tools\mongodb'
    $taskMongoCandidates = @(Get-ChildItem -LiteralPath $taskMongoDirectory -Recurse -Filter mongod.exe | Where-Object { $_.FullName -like ('*' + $taskMongoMetadata.version + '*') })
    if ($taskMongoCandidates.Count -ne 1) { throw 'No se encontro una unica distribucion MongoDB compatible dentro del proyecto. Ejecuta PREPARAR_EQUIPO.ps1.' }
    $mongoPath = $taskMongoCandidates[0].FullName
    $mongoLog = Join-Path $logDir 'mongodb.log'
    $process = Start-Process -FilePath $mongoPath -ArgumentList @('--bind_ip','127.0.0.1','--port','27018','--dbpath',('"' + $dataDir + '"'),'--logpath',('"' + $mongoLog + '"'),'--logappend') -RedirectStandardOutput (Join-Path $logDir 'mongodb-stdout.log') -RedirectStandardError (Join-Path $logDir 'mongodb-error.log') -WindowStyle Hidden -PassThru
    $taskServices += @{ name='mongodb'; id=$process.Id; executable=$mongoPath; started_at=$process.StartTime.ToUniversalTime().ToString('o') }
    Save-TaskServices
}
for ($attempt=0; $attempt -lt 30 -and -not (Test-TaskPort 27018); $attempt++) { Start-Sleep -Milliseconds 500 }
if (-not (Test-TaskPort 27018)) { throw 'MongoDB no inició. Consulta .logs/mongodb.log.' }

if (-not (Test-TaskPort $taskApiPort)) {
    $pythonPath = Join-Path $projectRoot 'backend\.venv\Scripts\python.exe'
    if (-not (Test-Path -LiteralPath $pythonPath)) { throw 'Falta el entorno virtual de Python. Consulta README.md.' }
    $taskStopToken = [guid]::NewGuid().ToString('N')
    $process = Start-Process -FilePath $pythonPath -WorkingDirectory (Join-Path $projectRoot 'backend') -ArgumentList @('iniciar_api_local.py',$taskApiPort,$taskStopToken) -RedirectStandardOutput (Join-Path $logDir 'backend.log') -RedirectStandardError (Join-Path $logDir 'backend-error.log') -WindowStyle Hidden -PassThru
    $taskServices += @{ name='backend'; port=$taskApiPort; stop_token=$taskStopToken; id=$process.Id; executable=$pythonPath; started_at=$process.StartTime.ToUniversalTime().ToString('o') }
    Save-TaskServices
}
for ($attempt=0; $attempt -lt 40; $attempt++) {
    try { $taskHealth = Invoke-RestMethod -Uri "http://127.0.0.1:$taskApiPort/api/health" -TimeoutSec 2; if ($taskHealth.status -eq 'ok' -and $taskHealth.database -eq 'mongodb') { break } }
    catch { Start-Sleep -Milliseconds 500 }
}
if (-not $taskHealth -or $taskHealth.status -ne 'ok' -or $taskHealth.database -ne 'mongodb') { throw 'La API no responde. Consulta .logs/backend-error.log y ejecuta DETENER_DEMO.cmd antes de reintentar.' }
if (-not (Test-TaskPort 5173)) {
    $vitePath = Join-Path $projectRoot 'frontend\node_modules\vite\bin\vite.js'
    if (-not (Test-Path -LiteralPath $vitePath)) { throw 'Faltan dependencias del frontend. Ejecuta npm ci en frontend.' }
    $process = Start-Process -FilePath $nodePath -WorkingDirectory (Join-Path $projectRoot 'frontend') -ArgumentList @(('"' + $vitePath + '"'),'preview','--host','127.0.0.1','--port','5173','--strictPort') -RedirectStandardOutput (Join-Path $logDir 'frontend.log') -RedirectStandardError (Join-Path $logDir 'frontend-error.log') -WindowStyle Hidden -PassThru
    $taskServices += @{ name='frontend'; id=$process.Id; executable=$nodePath; started_at=$process.StartTime.ToUniversalTime().ToString('o') }
    Save-TaskServices
}
Save-TaskServices
for ($attempt=0; $attempt -lt 40; $attempt++) {
    try {
        $health = Invoke-RestMethod -Uri 'http://127.0.0.1:5173/api/health' -TimeoutSec 2
        if ($health.status -eq 'ok') { Write-Output 'SkillPath listo en http://127.0.0.1:5173'; exit 0 }
    } catch { Start-Sleep -Milliseconds 500 }
}
throw 'La demo aún no responde. Consulta los registros en .logs.'

