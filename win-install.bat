@echo off
chcp 65001 >nul 2>&1
title pppppk Install (Windows)

REM ========== Get script directory safely ==========
set "SCRIPT_DIR=%~dp0"
set "PS_SCRIPT=%SCRIPT_DIR%win-install.ps1"

REM ========== Check if win-install.ps1 exists ==========
if not exist "%PS_SCRIPT%" (
    echo.
    echo [!] Error: win-install.ps1 not found
    echo     Expected location: %PS_SCRIPT%
    echo.
    echo     Make sure the folder structure is correct:
    echo     - win-install.ps1
    echo     - claude-config-bundle\
    echo.
    pause
    exit /b 1
)

REM ========== Check if PowerShell exists ==========
where powershell.exe >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [!] PowerShell not found
    echo     Please install PowerShell 5.1+
    echo     Download: https://aka.ms/powershell
    echo.
    pause
    exit /b 1
)

REM ========== Run deploy ==========
echo.
echo Starting pppppk deploy...
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS_SCRIPT%"

REM ========== Check exit code ==========
if %errorlevel% neq 0 (
    echo.
    echo [!] Deploy may have issues
    echo     Try running as administrator
    echo.
    pause
)
