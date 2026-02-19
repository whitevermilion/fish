## Set values
# Hide welcome message & ensure we are reporting fish as shell
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x SHELL /usr/bin/fish

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

if test -f ~/.config/fish/secret.fish
    source ~/.config/fish/secret.fish
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

## Tool configurations
# Use bat for man pages
set -xU MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -xU MANROFFOPT "-c"

## Prompt configuration
## Starship prompt
if status --is-interactive
   source ("/usr/bin/starship" init fish --print-full-init | psub)
   export PATH="$HOME/.cargo/bin:$PATH"
end

set fish_cursor_default block

## Pure theme configuration
if not functions -q fish_prompt
    fisher install pure-fish/pure
end
set -g pure_enable_git true
set -g pure_color_primary blue
set -g pure_color_success green
set -g pure_color_normal white
set -g pure_color_danger red
set -g pure_color_light white
set -g pure_color_dark black
# Git 状态显示优化
set -g pure_symbol_git_dirty "*"
set -g pure_symbol_git_unpulled_commits "⇣"
set -g pure_symbol_git_unpushed_commits "⇡"
set -g pure_symbol_git_stash "≡"

## Command helpers
## Advanced command-not-found hook
source /usr/share/doc/find-the-command/ftc.fish

## Functions
# Fish command history
function history
    builtin history --show-time='%F %T '
end

## Aliases
# Exit commands
alias q="exit"
alias :q="exit"

# File listing with eza
# alias ls 'eza -l --color=always --group-directories-first --icons'  # long format
alias ls 'eza --icons --group-directories-first'
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing

# Better alternatives
alias cat 'bat --style header,snip,changes'

# Directory navigation
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'

# System utilities
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias ip 'ip -color'
alias wget 'wget -c '
alias whph='/opt/whph/whph'
alias lg 'lazygit'
alias htop 'btop'
alias neofetch 'fastfetch'

# Package management
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias please 'sudo'

## Application settings
alias vi="nvim"
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx OPENER xdg-open

## Key bindings
## Fish Vi 模式 Colemak 键位映射
function fish_user_key_bindings
    # 保留基础 vi 行为
    fish_vi_key_bindings
    bind -M default -e j
    bind -M default -e k
    bind -M default -e l
    # Colemak 方向键：把 h n e i 当作 左 下 右 上
    bind -M normal h backward-char
    bind -M normal i forward-char

    bind -M normal u 'fish_vi_enter_insert_mode'
end

# 替换 pacman -Syu 为 garuda-update
function pacman
    if test "$argv[1]" = "-Syu"
        garuda-update
    else
        command pacman $argv
    end
end

## Tool initialization
# 初始化 zoxide
if command -v zoxide > /dev/null
    zoxide init fish --cmd cd | source
end

# 手动设置 z 别名
if command -v zoxide > /dev/null
    function z
        __zoxide_z $argv
        pwd
    end
    
    function zi
        __zoxide_zi $argv
        pwd
    end
end

## System information

function yazi
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"  # 使用 command 避免递归
    
    if test -f "$tmp"
        set cwd (cat "$tmp" | string trim)
        rm -f "$tmp"
        
        if test -n "$cwd" -a "$cwd" != "$PWD"
            builtin cd -- "$cwd"
        end
    else
        rm -f "$tmp"
    end
end

function y
    yazi $argv
end

function rustbook
    # 使用 :open 命令确保在新标签页打开
    qutebrowser ":open /home/red/Documents/.obsidian/rust_project/book-cn/book/index.html" &
end

# ============ 基础环境检测 ============
alias in-tmux='test -n "$TMUX" && echo "在tmux中" || echo "不在tmux中"'
alias in-kitty='echo $TERM | grep -q "kitty" && echo "在Kitty中" || echo "不在Kitty中"'

# ============ 3个实用函数 ============
# 1. 快速启动tmux（用当前目录名作为会话名）
function t
    set session_name (basename (pwd))
    tmux new -A -s $session_name
end

