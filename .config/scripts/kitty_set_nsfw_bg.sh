#!/bin/bash

find_dirs=(
    ~/Music/NSFW/wallpapers/h
    ~/Music/NSFW/wallpapers/r-h
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(
        find "${find_dirs[@]}" -mindepth 1 -maxdepth 1 -type f \
            \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) \
            -not -name '.DS_Store' |
            fzf
    )
fi

if [[ -z $selected ]]; then
    exit 0
fi

# set kitty background
BACKGROUND_IMAGE="$selected"
# BACKGROUND_IMAGE="/Users/neil/Desktop/example.jpg"

# check if file exists
if [ -z "$BACKGROUND_IMAGE" ]; then
    echo "please select a file"
    exit 1
fi

# set background image
echo "setting background image to $BACKGROUND_IMAGE"
kitty @ set-background-image "$BACKGROUND_IMAGE"
