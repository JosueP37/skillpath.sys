@echo off
setlocal
title Instalar y abrir SkillPath
echo SkillPath 1.0.0 - Instalacion local para Windows de 64 bits
echo La primera instalacion necesita Internet. No cierres esta ventana.
echo.
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0PREPARAR_EQUIPO.ps1" %*
if errorlevel 1 goto error
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0INICIAR_DEMO.ps1"
if errorlevel 1 goto error
set PYTHONUTF8=1
"%~dp0backend\.venv\Scripts\python.exe" "%~dp0scripts\crear_usuarios_demo.py"
if errorlevel 1 goto error
echo.
echo SkillPath listo. El manual incluye las cuentas de demostracion.
if not defined SKILLPATH_NO_BROWSER start "" "http://127.0.0.1:5173"
exit /b 0
:error
echo.
echo No se completo la instalacion. Revisa el mensaje anterior y la carpeta .logs.
echo Consulta INSTALACION_OTRA_MAQUINA.md o MANUAL_DE_USO.html.
if not defined SKILLPATH_NO_BROWSER pause
exit /b 1
