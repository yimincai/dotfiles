#!/usr/bin/env bash

# set it to ~/.zshrc or ~/.bashrc
# alias tmux-sessionizer='~/scripts/tmux-sessionizer.sh'
# bindkey -s '^f' 'tmux-sessionizer\n'  # 綁定 Ctrl+f 叫出 fzf

USE_LOG=false # Set to false to disable logging
LOG_FILE="$HOME/.tmux-sessionizer.log"

log() {
    if $USE_LOG; then
        echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" >>"$LOG_FILE"
    fi
}

log "Starting tmux-sessionizer script..."

# Define directories to search for projects
find_dirs=(
    ~/Development
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
    log "Creating new tmux session for $selected_name..."
    tmux new-session -ds "$selected_name" -c "$selected" \; send-keys 'clear' C-m
else
    log "Session $selected_name already exists."
fi

# Step 4: Attach or switch depending on context
if [[ -z "$TMUX" ]]; then
    log "Attaching to tmux session $selected_name..."
    tmux attach-session -t "$selected_name" || log "[warn] attach-session failed for $selected_name"
else
    if tmux switch-client -t "$selected_name" 2>/dev/null; then
        log "Successfully switched to tmux session $selected_name"
    else
        log "[warn] switch-client failed, checking session existence..."

        if tmux has-session -t "$selected_name" 2>/dev/null; then
            log "Opening new window in existing session $selected_name..."
            tmux new-window -t "$selected_name:" -c "$selected"
            tmux select-window -t "$selected_name:"
        else
            log "[warn] session $selected_name no longer exists, creating again..."
            tmux new-session -ds "$selected_name" -c "$selected" \; send-keys 'clear' C-m
            tmux switch-client -t "$selected_name"
        fi
    fi
fi

# Debug info
# echo "[info] selected: $selected"
# echo "[info] session name: $selected_name"
# log "tmux session list:"
# tmux list-sessions >>"$LOG_FILE"
