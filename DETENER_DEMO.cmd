@echo off
setlocal
title Detener SkillPath
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0DETENER_DEMO.ps1"
if errorlevel 1 (
    echo.
    echo No se pudo completar el cierre. Revisa el error mostrado arriba.
    pause
    exit /b 1
)
pause
