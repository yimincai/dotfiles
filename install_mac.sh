#!/bin/bash

# This script creates symlinks for dotfiles and installs necessary packages
# on MacOS using Homebrew or on Arch Linux using pacman/yay.
# It backs up existing files before creating symlinks if the user agrees.
# It is designed to be run from the directory where the dotfiles are located.

# Usage: ./install.sh
#
# Make sure to run this script from the directory where the dotfiles are located.

# when it meet any error, it will exit
set -euo pipefail

Green='\033[0;32m'
Red='\033[0;31m'
Blue='\033[1;34m'
Yellow='\033[0;33m'
Reset='\033[0m'

# This script should be run from the directory where the dotfiles are located
# and not from the home directory.
if [ "$(pwd)" == "$HOME" ]; then
    echo -e "${Red}❌ error: Please do not run this script from the home directory.${Reset}"
    exit 1
fi

# List of files/directories to symlink at the home directory
files=(
    ".vimrc"
    ".zshrc"
    ".gitconfig"
    ".gitignore"
    ".tmux.conf"
    "scripts" # This is a directory
)

# List of files/directories in the .config directory to symlink at ~/.config directory
files_in_config_folder_macOS=(
    ".config/alacritty"
    ".config/borders"
    ".config/kitty"
    ".config/nvim"
    ".config/sketchybar"
    ".config/skhd"
    ".config/yabai"
    ".config/ghostty"
)

# Create symlink based on OS type
create_symlink() {
    files_in_config_folder=("${files_in_config_folder_macOS[@]}")

    local backup_choice
    echo -e "${Yellow}Do you want to back up existing dotfiles before creating symlinks? (Yes/No): ${Reset}"
    read -r backup_choice
    backup_choice=$(echo "$backup_choice" | tr '[:upper:]' '[:lower:]')

    if [[ "$backup_choice" != "yes" && "$backup_choice" != "y" ]]; then
        backup_choice="no"
        echo -e "${Blue}Proceeding without backup by default.${Reset}"
    else
        backup_choice="yes"
        echo -e "${Blue}Proceeding with backup.${Reset}"
    fi

    # Create symlinks for files directly in HOME
    for file_item in "${files[@]}"; do
        source_file="$(pwd)/$file_item"
        target="$HOME/$file_item"

        if [ ! -e "$source_file" ]; then
            echo -e "${Red}❌ Source file/directory $source_file does not exist. Skipping.${Reset}"
            continue
        fi

        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ "$backup_choice" == "yes" ]; then
                backup="$target.bak"
                if [ -e "$backup" ] || [ -L "$backup" ]; then
                    echo -e "${Red}Removing existing backup $backup before creating new one.${Reset}"
                    rm -rf "$backup"
                fi
                echo -e "${Yellow}Backing up existing $target to $backup${Reset}"
                mv "$target" "$backup"
            else
                echo -e "${Yellow}Removing existing $target without backup.${Reset}"
                rm -rf "$target"
            fi
        fi

        echo -e "${Green}Creating symlink for $file_item: $target -> $source_file${Reset}"
        ln -snf "$source_file" "$target"
    done

    # Ensure $HOME/.config directory exists
    if [ ! -d "$HOME/.config" ]; then
        echo -e "${Green}Creating directory $HOME/.config${Reset}"
        mkdir -p "$HOME/.config"
    fi

    # Create symlink for config directory items
    for file_path_item in "${files_in_config_folder[@]}"; do
        source_file="$(pwd)/$file_path_item"
        target="$HOME/$file_path_item"

        if [ ! -e "$source_file" ]; then
            echo -e "${Red}❌ Source file/directory $source_file does not exist. Skipping.${Reset}"
            continue
        fi

        if [ -e "$target" ] || [ -L "$target" ]; then
            if [ "$backup_choice" == "yes" ]; then
                backup="$target.bak"
                if [ -e "$backup" ] || [ -L "$backup" ]; then
                    echo -e "${Red}Removing existing backup $backup${Reset}"
                    rm -rf "$backup"
                fi
                echo -e "${Yellow}Backing up existing $target to $backup${Reset}"
                mv "$target" "$backup"
            else
                echo -e "${Yellow}Removing existing $target without backup.${Reset}"
                rm -rf "$target"
            fi
        fi

        target_parent_dir=$(dirname "$target")
        if [ ! -d "$target_parent_dir" ]; then
            echo -e "${Green}Creating parent directory $target_parent_dir for $target${Reset}"
            mkdir -p "$target_parent_dir"
        fi
        echo -e "${Green}Creating symlink for $file_path_item: $target -> $source_file${Reset}"
        ln -snf "$source_file" "$target"
    done
}

macOS_installation() {
    if ! command -v brew &>/dev/null; then
        echo -e "${Yellow}Homebrew could not be found, installing...${Reset}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo -e "${Green}Homebrew is already installed, skipping installation script.${Reset}"
    fi

    echo -e "${Blue}Tapping FelixKratz/formulae for sketchybar...${Reset}"
    brew tap FelixKratz/formulae

    brew_packages=(
        "font-hack-nerd-font" "wget" "zsh" "tmux" "neovim" "git"
        "koekeishiya/formulae/yabai" "koekeishiya/formulae/skhd" "sketchybar"
        "fastfetch" "bat" "ripgrep" "fd" "fzf" "jq" "htop" "btop" "tree" "nmap"
        "go" "unzip" "ffmpeg" "zplug"
    )

    brew_cask_packages=(
        # "google-chrome" "visual-studio-code" "slack" "discord" "spotify"
        "obsidian" "alacritty" "kitty" "ghostty" "font-meslo-lg-nerd-font"
        "font-hack-nerd-font"
    )

    echo -e "${Blue}Installing CLI packages（brew install）${Reset}"
    for package in "${brew_packages[@]}"; do
        if ! brew list "$package" &>/dev/null; then
            echo -e "${Green}Installing $package...${Reset}"
            brew install "$package"
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done

    echo -e "${Blue}Installing GUI packages（brew install --cask）${Reset}"
    for package in "${brew_cask_packages[@]}"; do
        if ! brew list --cask "$package" &>/dev/null; then
            echo -e "${Green}Installing $package...${Reset}"
            brew install --cask "$package"
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done

    echo -e "${Blue}DONE with macOS installation steps!${Reset}"
}

# Main script execution

echo -e "${Blue}Starting dotfiles setup...${Reset}"
create_symlink
macOS_installation
echo -e "${Green}🎉 Dotfiles setup process complete! 🎉${Reset}"
echo -e "${Yellow}Please restart your terminal or source your shell configuration (e.g., source ~/.zshrc) for changes to take effect.${Reset}"

exit 0
