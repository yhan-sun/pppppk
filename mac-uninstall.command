#!/bin/bash
# pppppk 一键卸载 (macOS)
# 双击此文件即可运行

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
xattr -cr "$SCRIPT_DIR" 2>/dev/null
chmod +x "$SCRIPT_DIR"/mac-uninstall.sh 2>/dev/null

bash "$SCRIPT_DIR/mac-uninstall.sh"
