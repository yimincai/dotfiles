#!/usr/bin/env bash

# set it to ~/.zshrc or ~/.bashrc
# alias tmux-sessionizer='~/scripts/tmux-sessionizer.sh'
# bindkey -s '^f' 'tmux-sessionizer\n'  # 綁定 Ctrl+f 叫出 fzf

LOG_FILE="$HOME/.tmux-sessionizer.log" # Log file location
echo "$(date "+%Y-%m-%d %H:%M:%S") - Starting tmux-sessionizer script..." >>"$LOG_FILE"

# Define directories to search for projects
find_dirs=(
    ~/Development/GH
    ~/Development/Working/backend
    ~/Development/Working/app
    ~/Development/Working/cli
    ~/Development/Working/web
    ~/Development/Working/others
    ~/Development/DevOps/itracxing
    ~/Development/DevOps/tools
    ~/Development/SideProjects
    ~/Development/Testing
    ~/Development/Clones
    ~/Development/Personal
    ~/Development/Learning/c
    ~/Development/Learning/cpp
    ~/Development/Learning/cpplayground
    ~/Development/Learning/python
    ~/Development/Learning/js
    ~/Development/Learning/java
    ~/Development/Learning/rust
    ~/Development/Learning/golang
    ~/Development/Learning/css
    ~/Development/Learning/vue
    ~/Development/Learning/react
    ~/Development/Learning/flutter
    ~/Development/Learning/video
)

# Step 1: Select directory
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(
        find "${find_dirs[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf
    )
fi

[[ -z "$selected" ]] && exit 0

# Step 2: Secure session name conversion (avoid . or spaces)
selected_name=$(basename "$selected" | tr ". -" "__")

# Step 3: Check if session exists, create if it doesn't
if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Creating new tmux session for $selected_name..." >>"$LOG_FILE"
    tmux new-session -ds "$selected_name" -c "$selected" \; send-keys 'clear' C-m
else
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Session $selected_name already exists." >>"$LOG_FILE"
fi

# Step 4: Attach or switch depending on context
if [[ -z "$TMUX" ]]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") - Attaching to tmux session $selected_name..." >>"$LOG_FILE"
    tmux attach-session -t "$selected_name" || echo "$(date "+%Y-%m-%d %H:%M:%S") - [warn] attach-session failed for $selected_name" >>"$LOG_FILE"
else
    if tmux switch-client -t "$selected_name" 2>/dev/null; then
        echo "$(date "+%Y-%m-%d %H:%M:%S") - Successfully switched to tmux session $selected_name" >>"$LOG_FILE"
    else
        echo "$(date "+%Y-%m-%d %H:%M:%S") - [warn] switch-client failed, checking session existence..." >>"$LOG_FILE"

        if tmux has-session -t "$selected_name" 2>/dev/null; then
            echo "$(date "+%Y-%m-%d %H:%M:%S") - Opening new window in existing session $selected_name..." >>"$LOG_FILE"
            tmux new-window -t "$selected_name:" -c "$selected"
            tmux select-window -t "$selected_name:"
        else
            echo "$(date "+%Y-%m-%d %H:%M:%S") - [warn] session $selected_name no longer exists, creating again..." >>"$LOG_FILE"
            tmux new-session -ds "$selected_name" -c "$selected" \; send-keys 'clear' C-m
            tmux switch-client -t "$selected_name"
        fi
    fi
fi

# Debug info
echo "[info] selected: $selected"
echo "[info] session name: $selected_name"
echo "[info] tmux session list:" >>"$LOG_FILE"
tmux list-sessions >>"$LOG_FILE"
