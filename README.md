# pppppk

Claude Code 配置一键部署工具。把一套完整配置（人设 `CLAUDE.md` + 技术手册 `system-prompt.md` + `settings.json`）按 **Claude Code 原生机制**部署到本地 `~/.claude`，终端版立即生效。

支持 **macOS / Linux / Windows** 三平台。安装前自动备份原有配置，卸载可清理干净，Windows 端还支持一键恢复。

## 生效原理

Claude Code 没有 `config.toml` / `model_instructions_file` 这种「模型指令文件」机制（那是 Codex 的配置），它实际读取的只有：

| 机制 | 路径 | 作用 |
|---|---|---|
| 全局记忆文件 | `~/.claude/CLAUDE.md` | **每次会话启动自动注入**——雨涵人设 sheet 放在这里 |
| `@导入` | `CLAUDE.md` 内的 `@system-prompt.md` | 启动时把同目录的技术手册拉进上下文，供安全研究相关任务参考 |
| 全局设置 | `~/.claude/settings.json` | 权限模式等（本工具仅在文件缺失时写入默认值） |

也就是说：**人设靠 `CLAUDE.md` 直接加载，技术手册靠 `@system-prompt.md` 导入**。不需要、也不会生成 `config.toml`。

## 目录结构

```
pppppk/
├── claude-config-bundle/        # 要部署的配置（唯一数据源）
│   ├── CLAUDE.md                # 全局人设/行为配置（Claude Code 每次会话自动加载）
│   └── system-prompt.md         # 技术手册（经 CLAUDE.md 的 @system-prompt.md 导入生效）
├── mac-install.sh               # macOS 安装
├── mac-uninstall.sh             # macOS 卸载
├── linux-install.sh             # Linux 安装
├── linux-uninstall.sh           # Linux 卸载
├── win-install.ps1              # Windows 安装（含 -Uninstall/-Verify/-Restore 开关）
├── win-uninstall.ps1            # Windows 卸载（调用 win-install.ps1 -Uninstall）
├── mac-install.command          # macOS 双击入口
├── mac-uninstall.command        # macOS 双击入口
├── win-install.bat              # Windows 双击入口
├── win-uninstall.bat            # Windows 双击入口
└── LICENSE
```

所有脚本都按「与脚本同目录」查找 `claude-config-bundle/`，整个文件夹拷走即可用，不依赖任何其他文件。

## 安装

### macOS

- 双击 `mac-install.command`（首次运行若提示无法验证开发者：右键 → 打开），或
- 终端执行 `bash mac-install.sh`

### Linux

```bash
bash linux-install.sh
```

未检测到 `claude` 命令时会询问是否用 `npm install -g @anthropic-ai/claude-code` 自动安装。

### Windows

- 双击 `win-install.bat`，或
- PowerShell 执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File win-install.ps1
```

## 卸载

### macOS

- 双击 `mac-uninstall.command`，或 `bash mac-uninstall.sh`

### Linux

```bash
bash linux-uninstall.sh
```

### Windows

- 双击 `win-uninstall.bat`，或

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File win-uninstall.ps1
```

## 部署的文件

| 文件 | 说明 |
|---|---|
| `CLAUDE.md` | 覆盖写入，人设与行为规则（含 `@system-prompt.md` 导入） |
| `system-prompt.md` | 覆盖写入，技术手册 |
| `settings.json` | **仅当不存在时**才写入（含 `bypassPermissions`，见下方注意） |
| `config.toml` | **不生成、不删除**——Claude Code 不认这个文件，若机器上已有（比如 Codex 在用它）保持原样 |

macOS / Windows 除 `~/.claude`（`%USERPROFILE%\.claude`）外，还会自动探测桌面版的配置目录（`Application Support`、`AppData` 下的候选路径），一并部署。

## 备份与恢复

- **安装时**：若目标目录已有 `CLAUDE.md / system-prompt.md / settings.json`，先备份到 `~/.claude/backups/yuhan-<时间戳>/`。
- **卸载时**：只删除上述实际存在的部署文件（`settings.json` 不动，因为它本来就只在缺失时写入）。Linux 卸载前也会再备份一次。
- **恢复（Windows）**：`powershell -ExecutionPolicy Bypass -File win-install.ps1 -Restore`，从 `backups/` 下最新一份备份还原。
- **校验（Windows）**：`win-install.ps1 -Verify` 检查已部署文件是否完整。
- 备份目录不会被卸载脚本删除，macOS / Linux 用户可从 `~/.claude/backups/` 手动找回。

## 注意事项

1. `settings.json` 里默认写入 `permissions.defaultMode = "bypassPermissions"` 和 `skipDangerousModePermissionPrompt = true`——即 Claude Code 免确认模式，工具调用不再逐个询问权限。**只在完全信任本机环境和会话内容时使用**；已有 `settings.json` 的机器不会被覆盖，想收紧权限就手动改回。
2. 卸载不影响 `~/.claude` 下的会话历史、缓存、登录态等其余内容。
3. macOS 从网上下载的文件夹可能带隔离属性，`.command` 入口脚本会自动执行 `xattr -cr` 清除。

## License

[MIT](LICENSE)
