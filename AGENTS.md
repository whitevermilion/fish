# Fish Shell 配置目录概览

这是一个精心配置的 Fish Shell 环境，主要在 Arch Linux (Garuda) 系统上使用。目录包含了用户级别的 Fish Shell 配置文件、函数、插件和主题设置。

## 目录结构

```
/home/red/.config/fish/
├── config.fish              # 主配置文件
├── fish_variables           # Fish 全局变量定义
├── fish_plugins             # Fisher 插件列表
├── vi_mode.md              # Vi 模式命令参考文档
├── fish_math.md            # Fish 数学计算指南
├── completions/            # 命令补全脚本
├── conf.d/                 # 配置片段（按字母顺序加载）
└── functions/              # 自定义函数
```

## 项目类型

这是一个 **Shell 配置项目**，包含个人化的 Fish Shell 环境配置。

## 核心组件

### 1. 主配置文件 (`config.fish`)

主配置文件包含了以下主要设置：

#### 环境变量和路径
- 隐藏欢迎消息 (`fish_greeting`)
- 设置 SHELL 为 `/usr/bin/fish`
- 将 `~/.local/bin` 添加到 PATH
- 加载可选的 `~/.fish_profile` 和 `~/.config/fish/secret.fish`（敏感信息）

#### 工具配置
- 使用 `bat` 作为 man pager：`MANPAGER="sh -c 'col -bx | bat -l man -p'"`
- 默认编辑器：`nvim`（设置为 EDITOR 和 VISUAL）

#### 提示符系统
- **Starship Prompt**: 交互式 shell 中使用 Starship
- **Pure Theme**: 备用主题，配置了 git 状态显示
  - 启用 git 显示
  - 自定义颜色方案（主色调蓝色，成功色绿色）
  - 自定义 git 符号（脏目录 `*`，拉取 `⇣`，推送 `⇡`，stash `≡`）

#### 命令别名
- **退出命令**: `q`, `:q` → `exit`
- **文件列表**: `ls` → `eza`（带图标和目录优先）
- **树形列表**: `lt` → `eza -aT`
- **查看文件**: `cat` → `bat`
- **目录导航**: `..`, `...`, `....`（abbreviations）
- **系统工具**:
  - `grep`, `egrep`, `fgrep` → `ugrep`
  - `mirror` → `reflector`（更新 pacman 镜像）
  - `please` → `sudo`
  - `whph` → `/opt/whph/whph`
  - `lg` → `lazygit`
  - `vi` → `nvim`

#### Vi 模式键位映射
- 使用 Colemak 布局的方向键映射
- `h` → 向左移动
- `i` → 向右移动（进入插入模式）
- `u` → 进入插入模式
- 移除了标准的 `j` 和 `k` 键绑定

#### Pacman 覆盖
- `pacman -Syu` 被重定向到 `garuda-update`

#### 工具集成
- **Zoxide**: 智能目录跳转工具，覆盖 `cd` 命令，提供 `z` 和 `zi` 函数
- **Yazi**: 文件管理器，支持 cwd 追踪，快捷键 `y`
- **Lazygit**: 别名 `lg`
- **Tmux**: 函数 `t` 使用当前目录名创建 tmux 会话

### 2. Fisher 插件系统 (`fish_plugins`)

使用 Fisher 插件管理器，安装了以下插件：

1. **jorgebucaran/fisher** - Fisher 插件管理器本身
2. **pure-fish/pure** - 简洁的提示符主题
3. **jorgebucaran/autopair.fish** - 自动补全配对符号（括号、引号等）
4. **edc/bass** - 在 Fish 中执行 Bash 脚本

### 3. 配置片段 (`conf.d/`)

这些文件按字母顺序加载，用于组织和分离配置：

- **clashctl.fish**: Clash/Mihomo 代理管理
  - 代理控制函数（clashon, clashoff）
  - 环境变量设置（http_proxy, https_proxy, all_proxy, no_proxy）
- **done.fish**: 命令完成通知系统
  - 长时间命令完成后发送桌面通知
  - 支持多种通知系统（notify-send, terminal-notifier, osascript 等）
  - 最小命令持续时间：10 秒
  - 紧急级别：low
- **rust.fish**: Rust 工具链路径配置
  - 添加 `~/.cargo/bin` 到 PATH
- **mocha.fish**: Mocha 测试框架相关
- **pure.fish**: Pure 主题初始化
- **autopair.fish**: Autopair 插件配置
- **fish_frozen_key_bindings.fish**: 键位绑定相关
- **rustup.fish**: Rustup 工具相关

### 4. 自定义函数 (`functions/`)

包含大量自定义函数：

#### Pure 主题相关函数
- `_pure_*.fish` - Pure 主题的核心函数
  - 提示符渲染（git, k8s, AWS, 虚拟环境等）
  - 格式化和工具函数
  - 容器检测

#### 其他工具函数
- **bass.fish** - Bash 执行器
- **fish_greeting.fish** - Shell 启动问候（检查新版本）
- **fish_prompt.fish** - 提示符函数
- **fish_title.fish** - 终端标题设置
- **fish_mode_prompt.fish** - Vi 模式指示器

#### Autopair 函数
- `_autopair_*.fish` - 自动配对符号的功能函数

### 5. 文档文件

- **vi_mode.md**: Vi 模式命令参考
  - 命令模式、插入模式、视觉模式的键位说明
  - 光标形状配置指南
  - 撤销/重做操作

- **fish_math.md**: 数学计算指南
  - 使用 `math` 命令进行基础算术
  - 使用 `bc` 进行高精度浮点计算
  - 进制转换、三角函数、统计计算
  - 实用函数库示例

### 6. 全局变量 (`fish_variables`)

包含所有持久化的 Fish 全局变量，主要设置：
- Pure 主题的所有颜色和符号配置
- 环境变量（MANPAGER, MANROFFOPT）
- Fisher 插件追踪
- 用户路径（`~/.local/npm/bin`）

## 使用说明

### 启动和运行

1. **启动 Fish Shell**:
   ```bash
   fish
   ```

2. **重新加载配置**:
   ```bash
   source ~/.config/fish/config.fish
   ```

3. **测试配置**:
   - 启动新终端会话
   - 测试别名（如 `ls`, `lg`, `whph`）
   - 测试函数（如 `t`, `y`, `z`）

### 开发约定

#### 添加新别名
编辑 `config.fish`，在 `## Aliases` 部分添加：
```fish
alias new_command 'command_name --options'
```

#### 添加新函数
在 `functions/` 目录创建新函数文件：
```fish
# ~/.config/fish/functions/myfunction.fish
function myfunction
    # 函数体
end
```

或直接在 `config.fish` 中定义。

#### 添加新插件
编辑 `fish_plugins` 文件，添加插件行：
```
author/plugin-name
```

然后运行：
```fish
fisher update
```

#### 添加配置片段
在 `conf.d/` 目录创建 `.fish` 文件，文件名决定加载顺序（字母顺序）。

### 依赖工具

配置依赖于以下外部工具（通过包管理器安装）：

- **核心工具**:
  - `fish` - Fish Shell
  - `starship` - Starship 提示符
  - `eza` - 现代化的 ls 替代品
  - `bat` - 现代化的 cat 替代品
  - `nvim` - Neovim 编辑器
  - `ugrep` - 高性能 grep

- **开发工具**:
  - `git` - 版本控制
  - `lazygit` - Git TUI
  - `zoxide` - 智能目录跳转
  - `yazi` - 文件管理器

- **系统工具**:
  - `tmux` - 终端复用器
  - `find-the-command` - 命令未找到提示
  - `clash` / `mihomo` - 代理工具
  - `garuda-update` - Garuda 系统更新

- **Rust 工具链**:
  - `cargo`, `rustc`, `rustup`
  - 路径：`~/.cargo/bin`

### 特殊功能

#### Vi 模式
- 使用 Colemak 布局的方向键
- 光标形状会根据模式改变（方块/竖线/下划线）
- 支持撤销/重做

#### 智能目录跳转（Zoxide）
- `z <pattern>` - 跳转到匹配目录
- `zi <pattern>` - 使用模糊匹配跳转
- 覆盖了默认的 `cd` 命令

#### 代理管理（Clash）
- `clashon` - 开启代理并设置环境变量
- `clashoff` - 关闭代理并清理环境变量
- 代理信息保存到 `/var/proxy`

#### 命令完成通知
- 长时间命令（>10秒）完成后发送桌面通知
- 支持退出状态显示
- 窗口失焦时才发送通知

#### 文件管理（Yazi）
- `y` 或 `yazi` - 启动文件管理器
- 退出时自动跳转到 yazi 中选中的目录

### 故障排除

1. **配置未生效**:
   - 确保文件语法正确：`fish -n ~/.config/fish/config.fish`
   - 重新加载：`source ~/.config/fish/config.fish`

2. **插件问题**:
   - 查看已安装插件：`fisher list`
   - 更新插件：`fisher update`
   - 重装插件：编辑 `fish_plugins` 后运行 `fisher update`

3. **路径问题**:
   - 检查 PATH：`echo $PATH`
   - 查看全局变量：`set -U`

4. **Vi 模式问题**:
   - 检查键位绑定：`bind --all`
   - 查看当前模式：在命令模式查看提示符指示器

### 文件维护

- **config.fish**: 主配置，应该保持整洁和有注释
- **conf.d/**: 大型配置应该分解到独立文件
- **functions/**: 复杂的函数应该放在独立文件中
- **文档**: 重要功能应该有相应的文档说明（如 vi_mode.md, fish_math.md）

### Git 仓库信息

- 远程仓库：`git@gitee.com:whitevermilion/fish.git`
- 分支：`master`
- 配置文件已纳入版本控制
- `fish_variables` 当前有未提交的修改

### 注意事项

1. **敏感信息**: 使用 `secret.fish` 存储敏感配置，不应提交到版本控制
2. **兼容性**: 配置针对 Arch Linux/Garuda 系统，可能需要调整以适配其他发行版
3. **性能**: 配置加载了大量插件和函数，启动时间较长
4. **依赖**: 确保所有依赖工具已安装，否则某些功能可能无法使用