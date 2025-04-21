#!/bin/bash

# define wallpaper directories
WALLPAPER_DIRS=(
    "$HOME/Music/NSFW/wallpapers/h"
    "$HOME/Music/NSFW/wallpapers/r-h"
)

# use fzf to select a wallpaper directory
SELECTED_DIR=$(printf '%s\n' "${WALLPAPER_DIRS[@]}" | fzf --prompt="Select a wallpaper directory: ")

# check if a directory was selected
if [ -d "$SELECTED_DIR" ]; then
    echo "Selected directory: $SELECTED_DIR"
else
    echo "No valid directory selected. Exiting."
    exit 1
fi

# collect all wallpaper files in the selected directory
WALLPAPERS=()
while IFS= read -r -d '' file; do
    WALLPAPERS+=("$file")
done < <(find "$SELECTED_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) -print0)

# check if any wallpapers were found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in the selected directory."
    exit 1
fi

# randomly select a wallpaper
random_wallpaper="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
kitty @ set-background-image "$random_wallpaper"

# set the interval for changing wallpapers (in seconds)
INTERVAL=30
echo "Changing wallpaper every $INTERVAL seconds..."

# Run the wallpaper change function in the background
nohup bash -c "
    WALLPAPERS=(${WALLPAPERS[@]})
    change_wallpaper() {
        local random_wallpaper=\"\${WALLPAPERS[RANDOM % \${#WALLPAPERS[@]}]}\"
        kitty @ set-background-image \"\${random_wallpaper}\"
    }
    while true; do
        change_wallpaper
        sleep $INTERVAL
    done
" >/dev/null 2>&1 &
