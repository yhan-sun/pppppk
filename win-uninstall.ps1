# pppppk Windows 卸载脚本
# 用法: powershell -NoProfile -ExecutionPolicy Bypass -File win-uninstall.ps1
# 实际逻辑复用 win-install.ps1 的 -Uninstall 开关，保持单一实现

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$target = Join-Path $scriptDir 'win-install.ps1'

if (-not (Test-Path $target)) {
    Write-Host ''
    Write-Host '[!] Error: win-install.ps1 not found' -ForegroundColor Red
    Write-Host "    Expected location: $target" -ForegroundColor Red
    Write-Host ''
    Read-Host 'Press Enter to exit'
    exit 1
}

& $target -Uninstall
