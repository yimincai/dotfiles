#!/bin/bash

find_dirs=(
    ~/Documents/wallpapers/default
)

selected_dir=$(
    printf "%s\n" "${find_dirs[@]}" | fzf --prompt="Select wallpaper directory: "
)

if [[ -z $selected_dir ]]; then
    echo "No directory selected"
    exit 0
fi

selected_image=$(
    find "$selected_dir" -mindepth 1 -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) \
        -not -name '.DS_Store' |
        fzf --preview "kitty +kitten icat --stdin=detect --clear --place=80x24@140x5 --transfer-mode=memory --stdin < {} > /dev/tty" \
            --preview-window=right:40%:wrap \
            --prompt="Select wallpaper image: "
)

if [[ -z $selected_image ]]; then
    echo "No image selected"
    exit 0
fi

BACKGROUND_IMAGE="$selected_image"

if [ ! -f "$BACKGROUND_IMAGE" ]; then
    echo "The selected file does not exist"
    exit 1
fi

echo "Setting background image to $BACKGROUND_IMAGE"
kitty @ set-background-image "$BACKGROUND_IMAGE" >/dev/null 2>&1 &
