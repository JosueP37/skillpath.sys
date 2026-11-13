@echo off
setlocal
title Preparar SkillPath
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0PREPARAR_EQUIPO.ps1" %*
if errorlevel 1 (
    echo.
    echo No se completo la preparacion. Revisa el error mostrado arriba.
    pause
    exit /b 1
)
echo.
echo Preparacion lista. Abre INICIAR_DEMO.cmd.
pause
