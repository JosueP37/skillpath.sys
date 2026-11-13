@echo off
setlocal
title Iniciar SkillPath
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0INICIAR_DEMO.ps1"
if errorlevel 1 (
    echo.
    echo No se pudo iniciar SkillPath. Revisa el error y la carpeta .logs.
    pause
    exit /b 1
)
start "" "http://127.0.0.1:5173"
