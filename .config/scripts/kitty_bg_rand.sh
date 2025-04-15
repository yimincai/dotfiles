#!/bin/bash

# This script randomly changes the wallpaper in Kitty terminal.
WALLPAPER_DIRS=(
    # add your wallpaper directories here
    "$HOME/Music/NSFW/wallpapers/h"
    # "$HOME/Music/NSFW/wallpapers/r-h"
)

# set the interval in seconds
INTERVAL=30

# collect all wallpapers from the specified directories
WALLPAPERS=()
for DIR in "${WALLPAPER_DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        while IFS= read -r -d '' file; do
            WALLPAPERS+=("$file")
        done < <(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) -print0)
    else
        echo "Folder $DIR does not exist."
    fi
done

echo "Found ${#WALLPAPERS[@]} wallpapers in the specified folders, interval: $INTERVAL seconds."

# check if any wallpapers were found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in the specified folders."
    exit 1
fi

# change_wallpaper function
change_wallpaper() {
    local random_wallpaper="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
    kitty @ set-background-image "$random_wallpaper"
}

# main loop
while true; do
    change_wallpaper
    sleep "$INTERVAL"
done
