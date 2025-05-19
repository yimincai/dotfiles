#!/bin/bash

# This script creates symlinks for dotfiles and installs necessary packages
# on Arch Linux using pacman/yay.
# It backs up existing files before creating symlinks if the user agrees.
# It is designed to be run from the directory where the dotfiles are located.

# Usage: ./install_arch.sh
#
# Make sure to run this script from the directory where the dotfiles are located.

# when it meet any error, it will exit
set -euo pipefail

Green='\033[0;32m'
Red='\033[0;31m'
Blue='\033[1;34m'
Yellow='\033[0;33m'
Reset='\033[0m'

# --- Package Lists ---
pacman_packages=(
    "wget"
    "zsh"
    "tmux"
    "neovim"
    "git"
    "fastfetch"
    "bat"
    "ripgrep"
    "fd"
    "fzf"
    "jq"
    "htop"
    "btop"
    "tree"
    "nmap"
    "go"
    "unzip"
    "ffmpeg"
    "wl-clipboard"
    "bluez"
    "bluez-utils"
    "blueman"
    "zoxide"
)

aur_packages=(
    "kitty"
    "ghostty"
)

# --- Files and Directories to Symlink ---
files=(
    ".vimrc"
    ".zshrc"
    ".gitconfig"
    ".gitignore"
    ".tmux.conf"
    ".tmux"     # This is a directory
    "scripts" # This is a directory
)

files_in_config_folder=(
    ".config/alacritty"
    ".config/kitty"
    ".config/nvim"
    ".config/ghostty"
    ".config/hypr"
)

# --- Functions ---

# Create symlink
create_symlink() {
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
        ln -sf "$source_file" "$target"
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
        ln -sf "$source_file" "$target"
    done
}

arch_installation() {
    if ! command -v yay &>/dev/null; then
        echo -e "${Yellow}AUR helper 'yay' could not be found. Attempting to install...${Reset}"
        echo -e "${Yellow}This requires 'base-devel' group and 'git' to be installed.${Reset}"
        sudo pacman -S --noconfirm --needed base-devel git

        echo -e "${Yellow}Cloning yay from AUR to /tmp/yay...${Reset}"
        git clone https://aur.archlinux.org/yay.git /tmp/yay

        echo -e "${Yellow}Building and installing yay from /tmp/yay...${Reset}"
        (cd /tmp/yay && makepkg -si --noconfirm)

        echo -e "${Yellow}Cleaning up /tmp/yay...${Reset}"
        rm -rf /tmp/yay

        if ! command -v yay &>/dev/null; then
            echo -e "${Red}❌ Failed to install yay. Please install it manually and re-run.${Reset}"
            exit 1
        fi
    else
        echo -e "${Green}AUR helper 'yay' is already installed.${Reset}"
    fi

    echo -e "${Blue}Installing pacman packages（pacman -S）${Reset}"
    echo -e "${Blue}Updating pacman database...${Reset}"
    sudo pacman -Syu --noconfirm

    for package in "${pacman_packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            echo -e "${Green}Installing $package...${Reset}"
            sudo pacman -S --noconfirm --needed "$package"
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done

    echo -e "${Blue}Installing AUR packages（yay -S）${Reset}"
    for package in "${aur_packages[@]}"; do
        if ! yay -Q "$package" &>/dev/null; then
            echo -e "${Green}Installing $package...${Reset}"
            yay -S --noconfirm --needed "$package"
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done
    echo -e "${Blue}DONE with Arch Linux installation steps!${Reset}"
}

# --- Main script execution ---

echo -e "${Blue}Starting dotfiles setup for Arch Linux...${Reset}"

# Perform symlink creation
create_symlink

# Perform Arch Linux specific package installation
arch_installation

echo -e "${Green}🎉 Dotfiles setup process complete for Arch Linux! 🎉${Reset}"
echo -e "${Yellow}Please restart your terminal or source your shell configuration (e.g., source ~/.zshrc) for changes to take effect.${Reset}"

exit 0
