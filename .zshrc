export ZPLUG_HOME=/opt/homebrew/opt/zplug
# export ZPLUG_HOME=/usr/local/opt/zplug this is for intel mac
source $ZPLUG_HOME/init.zsh

zplug romkatv/powerlevel10k, as:theme
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "plugins/git",   from:oh-my-zsh, defer:3
zplug "modules/prompt", from:prezto, defer:3
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# Load if "if" tag returns true
zplug "lib/clipboard", from:oh-my-zsh, defer:2, if:"[[ $OSTYPE == *darwin* ]]"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/neil/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

gacp() {
    git add -A &&
    git commit -m "${1?'Missing commit message'}" &&
    git push
}

plugins=(
git
autojump
zsh-completions
zsh-autosuggestions
zsh-syntax-highlighting
)


# aliases
alias c="clear"
alias ll="ls -lA"
alias la="ls -a"
alias k="kubectl"
alias vim="nvim"
# find port pid, usage: fp tcp:3000
alias fp="lsof -i"
alias yd="youtubedr"
alias t="tmux"
alias cd="z"
# tmux
alias ts='~/.config/scripts/tmux-sessionizer.sh'
alias tc='~/.config/scripts/tmux-choose-session.sh'
# vpn
alias vpn='~/.config/scripts/vpn.sh'

# dotfiles
# export DOTFILES=$HOME/.dotfiles
# this is for linux
# alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# this is for mac
# alias dotfiles='/opt/homebrew/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# go cover
# usage: go-cover ./... <- this can replace to any path or relative path
cover () {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/neil/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/neil/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/neil/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/neil/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# mvn
export MAVEN_HOME=$HOME/apache-maven-3.8.2
export PATH=$PATH:$MAVEN_HOME/bin

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Flutter
export PATH="$PATH:$HOME/flutter/bin"
# Flutterfire (CLI)
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Java
# show all versions /usr/libexec/java_home -V
export JAVA_HOME=/Users/neil/Library/Java/JavaVirtualMachines/azul-19/Contents/Home

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Bun completions
[ -s "/Users/neil/.bun/_bun" ] && source "/Users/neil/.bun/_bun"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Rust
. "$HOME/.cargo/env"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Fixed the npm canvas install issue
export LDFLAGS="-L/opt/homebrew/opt/jpeg/lib"
export CPPFLAGS="-I/opt/homebrew/opt/jpeg/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/jpeg/lib/pkgconfig"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/neil/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/neil/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/neil/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/neil/google-cloud-sdk/completion.zsh.inc'; fi

# yazi, a terminal based file manager
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# zoxide, a cd replacement tool
eval "$(zoxide init zsh)"
