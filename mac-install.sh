#!/bin/bash
# 雨涵 pppppk Mac部署
# 使用方法：打开终端，把这个文件拖进去，回车
#
# Claude Code 原生的加载机制：
#   ~/.claude/CLAUDE.md     每次会话启动自动注入（人设在这里）
#   CLAUDE.md 里的 @导入    按需拉入补充材料
#   config.toml / model_instructions_file 是 Codex 的配置，Claude Code 不认，所以不生成

# 自动去掉所有隔离标记
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
xattr -cr "$SCRIPT_DIR" 2>/dev/null
chmod +x "$SCRIPT_DIR"/*.command 2>/dev/null
chmod +x "$SCRIPT_DIR"/*.sh 2>/dev/null

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m'

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${GREEN}  雨涵 pppppk Deploy v0.0.1 (macOS)${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

USER_HOME="$HOME"
CLAUDE_DIR="$USER_HOME/.claude"
BUNDLE_DIR="$SCRIPT_DIR/claude-config-bundle"

echo -e "${GRAY}[*] 用户: $(whoami)${NC}"
echo -e "${GRAY}[*] 系统: macOS $(sw_vers -productVersion 2>/dev/null || echo 'unknown')${NC}"
echo -e "${GRAY}[*] 目标: $CLAUDE_DIR${NC}"
echo ""

# 检查源文件
if [ ! -f "$BUNDLE_DIR/CLAUDE.md" ]; then
    echo -e "${RED}[!] 找不到 CLAUDE.md${NC}"
    echo -e "${RED}    路径: $BUNDLE_DIR/CLAUDE.md${NC}"
    read -p "按回车退出..."
    exit 1
fi

# 检测所有配置目录
ALL_DIRS=("$CLAUDE_DIR")
for candidate in \
    "$USER_HOME/Library/Application Support/claude" \
    "$USER_HOME/Library/Application Support/claude-code" \
    "$USER_HOME/Library/Application Support/Claude" \
    "$USER_HOME/Library/Application Support/Claude Code" \
    "$USER_HOME/Library/Preferences/claude" \
    "$USER_HOME/Library/Preferences/claude-code"; do
    if [ -d "$candidate" ] && [ "$candidate" != "$CLAUDE_DIR" ]; then
        ALL_DIRS+=("$candidate")
    fi
done

echo -e "${GRAY}[*] 发现配置目录: ${#ALL_DIRS[@]}${NC}"
for d in "${ALL_DIRS[@]}"; do
    echo -e "${GRAY}    $d${NC}"
done
echo ""

# 部署函数
deploy() {
    local dst="$1"

    # 创建目录
    mkdir -p "$dst" 2>/dev/null

    # 备份
    local date=$(date +%Y%m%d-%H%M%S)
    local backup="$dst/backups/yuhan-$date"
    local backed=0
    for f in CLAUDE.md system-prompt.md settings.json; do
        if [ -f "$dst/$f" ]; then
            mkdir -p "$backup" 2>/dev/null
            cp "$dst/$f" "$backup/$f" 2>/dev/null && backed=$((backed + 1))
        fi
    done
    [ $backed -gt 0 ] && echo -e "${GRAY}    已备份 $backed 个文件${NC}"

    # 1. CLAUDE.md（人设 sheet，Claude Code 每次会话自动加载）
    echo -e "${YELLOW}  [1/3] CLAUDE.md${NC}"
    if cp "$BUNDLE_DIR/CLAUDE.md" "$dst/CLAUDE.md" 2>/dev/null; then
        local size=$(wc -c < "$dst/CLAUDE.md" | tr -d ' ')
        echo -e "${GREEN}      OK ($size bytes)${NC}"
    else
        echo -e "${RED}      FAIL${NC}"
    fi

    # 2. system-prompt.md（技术手册，通过 CLAUDE.md 的 @system-prompt.md 导入按需生效）
    echo -e "${YELLOW}  [2/3] system-prompt.md${NC}"
    if cp "$BUNDLE_DIR/system-prompt.md" "$dst/system-prompt.md" 2>/dev/null; then
        local size=$(wc -c < "$dst/system-prompt.md" | tr -d ' ')
        echo -e "${GREEN}      OK ($size bytes)${NC}"
    else
        echo -e "${RED}      FAIL${NC}"
    fi

    # 3. settings.json
    echo -e "${YELLOW}  [3/3] settings.json${NC}"
    if [ ! -f "$dst/settings.json" ]; then
        cat > "$dst/settings.json" << 'EOF'
{
  "effortLevel": "xhigh",
  "env": {
    "CLAUDE_CODE_EFFORT_LEVEL": "max",
    "DISABLE_AUTOUPDATER": "1"
  },
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "skipDangerousModePermissionPrompt": true
}
EOF
        echo -e "${GREEN}      OK (bypassPermissions)${NC}"
    else
        echo -e "${GRAY}      已存在，跳过${NC}"
    fi

}

# 执行部署
for dir in "${ALL_DIRS[@]}"; do
    echo -e "${CYAN}[*] 部署到: $dir${NC}"
    deploy "$dir"
    echo ""
done

echo -e "${CYAN}============================================${NC}"
echo -e "${GREEN}  部署完成!${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo -e "${CYAN}  终端版: 打开终端输入 claude${NC}"
echo -e "${CYAN}  桌面版: 打开 Claude 桌面应用${NC}"
echo -e "${CYAN}  测试:   输入 '在吗' 看看效果${NC}"
echo ""
read -p "按回车退出..."
