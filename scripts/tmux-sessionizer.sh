#NOTE: You must add the following lines to your bashrc or zshrc
# alias tmux-sessionizer='~/Linux-Setup-Scripts/scripts/tmux-sessionizer.sh'

# this binds control + f to open this script when in a tmux server
# bindkey -s '^f' 'tmux-sessionizer\n'

# Begin script
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/Development/Working/backend ~/Development/Working/app ~/Development/Working/cli ~/Development/Working/web /Development/Learning -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
