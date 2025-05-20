# 基本環境變數
export TERM="xterm-256color"
export EDITOR="nvim"
export KITTY_SOCK_DIR=/tmp/kitty

# zplug 安裝位置
export ZPLUG_HOME="$HOME/.zplug/"
source $ZPLUG_HOME/init.zsh

# 主題 (powerlevel10k)
zplug romkatv/powerlevel10k, as:theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zplug 自我管理
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 統一用 zplug 管理插件
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "plugins/git", from:oh-my-zsh, defer:3
zplug "modules/prompt", from:prezto, defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2

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
# export ZSH="/Users/neil/.oh-my-zsh"

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

# alias 總整理
alias c="clear"
alias ll="ls -lA"
alias la="ls -a"
alias k="kubectl"
alias vim="nvim"
alias fp="lsof -i"
alias yd="youtubedr"
alias t="tmux"
# alias cd="z"
alias ts='~/scripts/tmux-sessionizer.sh'
alias tc='~/scripts/tmux-choose-session.sh'
alias vpn='~/scripts/vpn.sh'
alias zz='yazi'
alias ok='~/scripts/kitty_socket.sh'
alias sbg='~/scripts/kitty_set_bg.sh'
alias gg='~/scripts/kitty_remove_bg.sh'
alias nbgr='~/scripts/kitty_bg_rand.sh'
alias nbg='~/scripts/kitty_set_nsfw_bg.sh'

# Golang
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

