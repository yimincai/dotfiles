bindkey -v

function vi-jk-escape() {
  # Read the next key, with short timeout
  read -t 0.15 -k 1 next
  if [[ $next == "k" ]]; then
    zle vi-cmd-mode
  else
    LBUFFER+="j$next"
  fi
}
zle -N vi-jk-escape
bindkey '^F' autosuggest-accept
bindkey -M viins 'j' vi-jk-escape

# 基本環境變數
export TERM="xterm-256color"
export EDITOR="nvim"
export KITTY_SOCK_DIR=/tmp/kitty

# zplug 安裝位置
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

# 主題 (powerlevel10k)
zplug romkatv/powerlevel10k, as:theme
# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

# zplug 自我管理
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 統一用 zplug 管理插件
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "modules/prompt", from:prezto, defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# macOS 特有插件，剪貼簿支援
zplug "lib/clipboard", from:oh-my-zsh, defer:2, if:"[[ $OSTYPE == *darwin* ]]"

# 檢查並提示安裝缺少插件
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# 載入所有插件與主題
zplug load

# oh-my-zsh 主目錄（部分插件可能需要）
export ZSH="$HOME/.oh-my-zsh"

# 主題設定 (影響 oh-my-zsh 核心組件)
ZSH_THEME="powerlevel10k/powerlevel10k"

# Powerlevel10k 即時提示
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH 基本設定
export PATH=$HOME/bin:/usr/local/bin:$PATH

# 自訂函數
gacp() {
    git add -A &&
    git commit -m "${1?'Missing commit message'}" &&
    git push
}

cover () {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# alias
alias c="clear"
alias ll="ls -lA"
alias la="ls -a"
alias k="kubectl"
alias vim="nvim"
alias fp="lsof -i"
alias yd="youtubedr"
alias t="tmux"
alias cd="z"
alias ts='$HOME/scripts/tmux-sessionizer.sh'
alias tc='$HOME/scripts/tmux-choose-session.sh'
alias vpn='$HOME/scripts/vpn.sh'
alias zz='yazi'
alias ok='$HOME/scripts/kitty_socket.sh'
alias sbg='$HOME/scripts/kitty_set_bg.sh'
alias gg='$HOME/scripts/kitty_remove_bg.sh'
alias nbgr='$HOME/scripts/kitty_bg_rand.sh'
alias nbg='$HOME/scripts/kitty_set_nsfw_bg.sh'

# conda init (miniforge)
__conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Maven
export MAVEN_HOME=$HOME/apache-maven-3.8.2
export PATH=$PATH:$MAVEN_HOME/bin

# Golang
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Flutter & Flutterfire CLI
export PATH="$PATH:$HOME/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Java (Azul JDK 19)
export JAVA_HOME=$HOME/Library/Java/JavaVirtualMachines/azul-19/Contents/Home

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rust
. "$HOME/.cargo/env"

# PostgreSQL libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Fix npm canvas install
export LDFLAGS="-L/opt/homebrew/opt/jpeg/lib"
export CPPFLAGS="-I/opt/homebrew/opt/jpeg/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/jpeg/lib/pkgconfig"

# Google Cloud SDK PATH & Completion
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# zoxide (cd 替代工具)
eval "$(zoxide init zsh)"

# Docker CLI 補全
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

