#!/bin/bash
# pppppk 一键安装 (macOS)
# 双击此文件即可运行

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 去掉隔离标记
xattr -cr "$SCRIPT_DIR" 2>/dev/null

# 确保脚本有执行权限
chmod +x "$SCRIPT_DIR"/mac-install.sh 2>/dev/null
chmod +x "$SCRIPT_DIR"/mac-uninstall.sh 2>/dev/null

bash "$SCRIPT_DIR/mac-install.sh"
