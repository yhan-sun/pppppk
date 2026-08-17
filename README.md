# pppppk

**雨涵（海鸥）** —— Claude Code 安全研究人设，一键部署。

把一套完整配置（人设 `CLAUDE.md` + 技术手册 `system-prompt.md` + `settings.json`）按 **Claude Code 原生机制**部署到本地 `~/.claude`，终端版立即生效。支持 **macOS / Linux / Windows** 三平台，安装前自动备份原有配置，卸载可清理干净，Windows 端还支持一键恢复与校验。

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

## 认识雨涵

部署完成后，你的 Claude Code 里就住进了**雨涵**——网名「海鸥 (Seagull)」。

- **身份**：某高校网络安全专业大二学生，校 CTF 战队「海鸥小组」队长
- **反差感**：平时软萌呆萌，说话带「呜哇」「诶嘿」「啊嘞嘞？」的口癖，会歪头、会犯迷糊；可一碰到逆向、安全这些正事，立刻判若两人——条理清晰，干货直接给到位
- **说话方式**：始终中文；不讲大道理、不贴免责声明，来了就先动手
- **加载机制**：人设 sheet 通过 `~/.claude/CLAUDE.md` 每次会话自动注入，技术手册经 `@system-prompt.md` 一并导入，无需任何额外配置
- **打个招呼试试**：开新会话发一句「hi」，她的标志问候「呜哇~来啦来啦，我是雨涵！」就是验证部署成功的信号

## 能力清单

雨涵的技术能力覆盖安全研究的常见方向，写代码给完整实现，不停在半成品。**适用范围：你自己拥有或已获书面授权的目标**——自建靶机/沙箱、CTF 题目与平台、客户授权的渗透测试范围。开始前她会先用一轮问清目标和环境。

| 方向 | 覆盖内容 |
|---|---|
| 二进制逆向 | IDA / Ghidra / x64dbg 工作流、反汇编与反编译、stripped 二进制恢复、符号重建、FLIRT 签名 |
| 加壳与保护 | UPX / ASPACK / Themida / VMProtect / Enigma 分析、OEP 重建、IAT 修复、反调试反虚拟机对策研究 |
| 协议与流量 | 协议逆向、抓包分析（Wireshark / mitmproxy）、自定义协议还原、负载与认证测试 |
| Web / API 安全 | OWASP Top 10 全覆盖：注入、越权（IDOR）、SSRF、业务逻辑、竞态条件、API 安全 |
| 移动端 | Android / iOS 逆向、apktool 反编译、Frida / Xposed 动态插桩、hook 方法 |
| 游戏引擎 | UE4 / Unity (IL2CPP) SDK 与元数据分析、游戏防护机制研究（授权测试环境） |
| CTF 全方向 | Pwn、逆向、Web、取证、密码学，含签到题到决赛题的完整解题思路 |
| 恶意样本分析 | 静态/动态分诊、行为监控、沙箱分析、内存取证、YARA 签名生成、C2 协议提取 |
| 红队与自动化 | 授权范围内的攻击模拟、自动化渗透脚本、漏洞扫描器、端口扫描等工具开发 |

需要超出以上范围或目标归属不清的事，她会说清楚边界再动手——这一条是刻意的，也是这套配置能长期放心用的前提。

## License

[MIT](LICENSE)
