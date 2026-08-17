# pppppk

Claude Code 配置一键部署工具。把一套完整配置（人设 `CLAUDE.md` + 模型指令 `system-prompt.md` + `settings.json` + `config.toml`）部署到本地 `~/.claude`，终端版和桌面版立即生效。

支持 **macOS / Linux / Windows** 三平台。安装前自动备份原有配置，卸载可清理干净，Windows 端还支持一键恢复。

## 目录结构

```
pppppk/
├── claude-config-bundle/        # 要部署的配置（唯一数据源）
│   ├── CLAUDE.md                # 全局人设/行为配置
│   └── system-prompt.md         # 模型指令文件
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
| `CLAUDE.md` | 覆盖写入，人设与行为规则 |
| `system-prompt.md` | 覆盖写入，模型指令 |
| `config.toml` | 覆盖写入，指向 `system-prompt.md` |
| `settings.json` | **仅当不存在时**才写入（含 `bypassPermissions`，见下方注意） |

macOS / Windows 除 `~/.claude`（`%USERPROFILE%\.claude`）外，还会自动探测桌面版的配置目录（`Application Support`、`AppData` 下的候选路径），一并部署。

## 备份与恢复

- **安装时**：若目标目录已有 `CLAUDE.md / system-prompt.md / config.toml / settings.json`，先备份到 `~/.claude/backups/yuhan-<时间戳>/`。
- **卸载时**：只删除上述 3 个配置文件中实际存在的（`settings.json` 不动，因为它本来就只在缺失时写入）。Linux 卸载前也会再备份一次。
- **恢复（Windows）**：`powershell -ExecutionPolicy Bypass -File win-install.ps1 -Restore`，从 `backups/` 下最新一份备份还原。
- **校验（Windows）**：`win-install.ps1 -Verify` 检查已部署文件是否完整。
- 备份目录不会被卸载脚本删除，macOS / Linux 用户可从 `~/.claude/backups/` 手动找回。

## 注意事项

1. `settings.json` 里默认写入 `permissions.defaultMode = "bypassPermissions"` 和 `skipDangerousModePermissionPrompt = true`——即 Claude Code 免确认模式，工具调用不再逐个询问权限。**只在完全信任本机环境和会话内容时使用**；已有 `settings.json` 的机器不会被覆盖，想收紧权限就手动改回。
2. 卸载不影响 `~/.claude` 下的会话历史、缓存、登录态等其余内容。
3. macOS 从网上下载的文件夹可能带隔离属性，`.command` 入口脚本会自动执行 `xattr -cr` 清除。

## License

[MIT](LICENSE)
