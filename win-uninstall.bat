@echo off
chcp 65001 >nul 2>&1
title pppppk Uninstall (Windows)

REM ========== Get script directory safely ==========
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%win-uninstall.ps1"

REM ========== Check if win-uninstall.ps1 exists ==========
if not exist "%PS_SCRIPT%" (
    echo.
    echo [!] Error: win-uninstall.ps1 not found
    echo     Expected location: %PS_SCRIPT%
    echo.
    pause
    exit /b 1
)

REM ========== Check if PowerShell exists ==========
where powershell.exe >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [!] PowerShell not found
    echo.
    pause
    exit /b 1
)

REM ========== Run uninstall ==========
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

if %errorlevel% neq 0 (
    echo.
    echo [!] Uninstall may have issues
    echo.
    pause
)
