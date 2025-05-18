#!/bin/bash

# This script creates symlinks for dotfiles and installs necessary packages
# on MacOS using Homebrew or on Arch Linux using pacman/yay.
# It backs up existing files before creating symlinks if the user agrees.
# It supports a --dryrun mode to show what would be done without making changes.
# It is designed to be run from the directory where the dotfiles are located.

# Usage: ./install.sh [--dryrun]
#
# Make sure to run this script from the directory where the dotfiles are located.

# when it meet any error, it will exit
set -euo pipefail

Green='\033[0;32m'
Red='\033[0;31m'
Blue='\033[1;34m'
Yellow='\033[0;33m'
Reset='\033[0m'

# --- Argument Parsing for --dryrun ---
DRY_RUN=false
DRY_RUN_PREFIX=""
if [[ "${1:-}" == "--dryrun" ]]; then # Check if $1 exists and is --dryrun
    DRY_RUN=true
    DRY_RUN_PREFIX="[DRY RUN] "
    echo -e "${Blue}>>> DRY RUN mode enabled. No changes will be made. <<<\n${Reset}"
fi

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
    ".tmux"   # This is a directory
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
    ".config/hypr"
)

# List of files/directories in the .config directory to symlink at ~/.config directory
# for linux-based systems
files_in_config_folder_linux=(
    ".config/alacritty"
    ".config/kitty"
    ".config/nvim"
    ".config/ghostty"
)

detect_os() {
    case "$OSTYPE" in
    darwin*)
        echo "mac"
        ;;
    linux*)
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            if [[ "$ID" == "arch" ]]; then
                echo "arch"
            else
                echo -e "${Red}❌ This script is designed for Arch Linux only.${Reset}"
                exit 1
            fi
        else
            eche -e "${Red}❌ Cannot determine Linux distro: /etc/os-release missing${Reset}"
            exit 1
        fi
        ;;
    *)
        echo -e "${Red}❌ Unknown or unsupported OS type: $OSTYPE.${Reset}"
        exit 1
        ;;
    esac
}

# Create symlink based on OS type
create_symlink() {
    local os="$1"
    case "$os" in
    mac)
        echo -e "${Blue}Creating macOS-specific symlink...${Reset}"
        files_in_config_folder=("${files_in_config_folder_macOS[@]}")
        ;;
    arch)
        echo -e "${Blue}Creating Arch Linux-specific symlink...${Reset}"
        files_in_config_folder=("${files_in_config_folder_linux[@]}")
        ;;
    *)
        echo -e "${Red}❌ Unknown or unsupported OS: $os${Reset}"
        exit 1
        ;;
    esac

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
                    echo -e "${Red}${DRY_RUN_PREFIX}Removing existing backup $backup before creating new one.${Reset}"
                    if [ ! "$DRY_RUN" = true ]; then
                        rm -rf "$backup"
                    fi
                fi
                echo -e "${Yellow}${DRY_RUN_PREFIX}Backing up existing $target to $backup${Reset}"
                if [ ! "$DRY_RUN" = true ]; then
                    mv "$target" "$backup"
                fi
            else
                echo -e "${Yellow}${DRY_RUN_PREFIX}Removing existing $target without backup.${Reset}"
                if [ ! "$DRY_RUN" = true ]; then
                    rm -rf "$target"
                fi
            fi
        fi

        echo -e "${Green}${DRY_RUN_PREFIX}Creating symlink for $file_item: $target -> $source_file${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            ln -sf "$source_file" "$target"
        fi
    done

    # Ensure $HOME/.config directory exists
    if [ ! -d "$HOME/.config" ]; then
        echo -e "${Green}${DRY_RUN_PREFIX}Creating directory $HOME/.config${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            mkdir -p "$HOME/.config"
        fi
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
                    echo -e "${Red}${DRY_RUN_PREFIX}Removing existing backup $backup${Reset}"
                    if [ ! "$DRY_RUN" = true ]; then
                        rm -rf "$backup"
                    fi
                fi
                echo -e "${Yellow}${DRY_RUN_PREFIX}Backing up existing $target to $backup${Reset}"
                if [ ! "$DRY_RUN" = true ]; then
                    mv "$target" "$backup"
                fi
            else
                echo -e "${Yellow}${DRY_RUN_PREFIX}Removing existing $target without backup.${Reset}"
                if [ ! "$DRY_RUN" = true ]; then
                    rm -rf "$target"
                fi
            fi
        fi

        target_parent_dir=$(dirname "$target")
        if [ ! -d "$target_parent_dir" ]; then
            echo -e "${Green}${DRY_RUN_PREFIX}Creating parent directory $target_parent_dir for $target${Reset}"
            if [ ! "$DRY_RUN" = true ]; then
                mkdir -p "$target_parent_dir"
            fi
        fi
        echo -e "${Green}${DRY_RUN_PREFIX}Creating symlink for $file_path_item: $target -> $source_file${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            ln -sf "$source_file" "$target"
        fi
    done
}

macOS_installation() {
    if ! command -v brew &>/dev/null; then
        echo -e "${Yellow}${DRY_RUN_PREFIX}Homebrew could not be found, installing...${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    else
        echo -e "${Green}Homebrew is already installed, skipping installation script.${Reset}"
    fi

    echo -e "${Blue}${DRY_RUN_PREFIX}Tapping FelixKratz/formulae for sketchybar...${Reset}"
    if [ ! "$DRY_RUN" = true ]; then
        brew tap FelixKratz/formulae
    fi

    brew_packages=(
        "font-hack-nerd-font" "wget" "zsh" "tmux" "neovim" "git"
        "koekeishiya/formulae/yabai" "koekeishiya/formulae/skhd" "sketchybar"
        "fastfetch" "bat" "ripgrep" "fd" "fzf" "jq" "htop" "btop" "tree" "nmap"
        "go" "unzip" "ffmpeg" "zplug"
    )
    brew_cask_packages=(
        # "google-chrome" "visual-studio-code" "slack" "discord" "spotify"
        "obsidian" "alacritty" "kitty" "ghostty", "font-meslo-lg-nerd-font"
        "font-hack-nerd-font"
    )

    echo -e "${Blue}{DRY_RUN_PREFIX}Installing CLI packages（brew install）${Reset}"
    for package in "${brew_packages[@]}"; do
        if ! brew list "$package" &>/dev/null; then
            echo -e "${Green}${DRY_RUN_PREFIX}Installing $package...${Reset}"
            if [ ! "$DRY_RUN" = true ]; then
                brew install "$package"
            fi
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done

    echo -e "${Blue}${DRY_RUN_PREFIX}Installing GUI packages（brew install --cask）${Reset}"
    for package in "${brew_cask_packages[@]}"; do
        if ! brew list --cask "$package" &>/dev/null; then
            echo -e "${Green}${DRY_RUN_PREFIX}Installing $package...${Reset}"
            if [ ! "$DRY_RUN" = true ]; then
                brew install --cask "$package"
            fi
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done

    echo -e "${Blue}${DRY_RUN_PREFIX}DONE with macOS installation steps!${Reset}"
}

arch_installation() {
    if ! command -v yay &>/dev/null; then
        echo -e "${Yellow}${DRY_RUN_PREFIX}AUR helper 'yay' could not be found. Attempting to install...${Reset}"
        echo -e "${Yellow}${DRY_RUN_PREFIX}This requires 'base-devel' group and 'git' to be installed.${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            sudo pacman -S --noconfirm --needed base-devel git
        else
            echo -e "${Yellow}${DRY_RUN_PREFIX}Would ensure 'base-devel' and 'git' are installed via: sudo pacman -S --noconfirm --needed base-devel git${Reset}"
        fi

        echo -e "${Yellow}${DRY_RUN_PREFIX}Cloning yay from AUR to /tmp/yay...${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            git clone https://aur.archlinux.org/yay.git /tmp/yay
        fi

        echo -e "${Yellow}${DRY_RUN_PREFIX}Building and installing yay from /tmp/yay...${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            (cd /tmp/yay && makepkg -si --noconfirm)
        fi

        echo -e "${Yellow}${DRY_RUN_PREFIX}Cleaning up /tmp/yay...${Reset}"
        if [ ! "$DRY_RUN" = true ]; then
            rm -rf /tmp/yay
        fi

        if ! command -v yay &>/dev/null && [ ! "$DRY_RUN" = true ]; then
            echo -e "${Red}❌ Failed to install yay. Please install it manually and re-run.${Reset}"
            exit 1
        elif [ "$DRY_RUN" = true ] && ! command -v yay &>/dev/null; then
            echo -e "${Yellow}[DRY RUN] Yay would be installed. Assuming success for further dry run steps.${Reset}"
        fi
    else
        echo -e "${Green}AUR helper 'yay' is already installed.${Reset}"
    fi

    pacman_packages=(
        "wget" "zsh" "tmux" "neovim" "git" "fastfetch" "bat" "ripgrep" "fd"
        "fzf" "jq" "htop" "btop" "tree" "nmap" "go" "unzip" "ffmpeg"
    )
    aur_packages=(
        "kitty" "ghostty" "zplug-git" "nerd-fonts-hack"
    )

    echo -e "${Blue}${DRY_RUN_PREFIX}Installing pacman packages（pacman -S）${Reset}"
    echo -e "${Blue}${DRY_RUN_PREFIX}Updating pacman database...${Reset}"
    if [ ! "$DRY_RUN" = true ]; then
        sudo pacman -Syu --noconfirm
    fi

    for package in "${pacman_packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            echo -e "${Green}${DRY_RUN_PREFIX}Installing $package...${Reset}"
            if [ ! "$DRY_RUN" = true ]; then
                sudo pacman -S --noconfirm --needed "$package"
            fi
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done

    echo -e "${Blue}${DRY_RUN_PREFIX}Installing AUR packages（yay -S）${Reset}"
    for package in "${aur_packages[@]}"; do
        # In dry run, if yay itself wasn't found, we can't check yay -Q
        can_check_aur=true
        if ! command -v yay &>/dev/null && [ "$DRY_RUN" = true ]; then
            can_check_aur=false
        fi

        if $can_check_aur && ! yay -Q "$package" &>/dev/null; then
            echo -e "${Green}${DRY_RUN_PREFIX}Installing $package...${Reset}"
            if [ ! "$DRY_RUN" = true ]; then
                yay -S --noconfirm --needed "$package"
            fi
        elif ! $can_check_aur; then # yay not installed, in dry run mode
            echo -e "${Green}${DRY_RUN_PREFIX}Installing $package (assuming not installed as yay check skipped)...${Reset}"
        else
            echo -e "${Yellow}$package is already installed, skipping.${Reset}"
        fi
    done
    echo -e "${Blue}${DRY_RUN_PREFIX}DONE with Arch Linux installation steps!${Reset}"
}

installation() {
    local os="$1"

    case "$os" in
    mac)
        macOS_installation
        ;;
    arch)
        arch_installation
        ;;
    *)
        echo -e "${Red}❌ Unknown OS type: $os. Cannot proceed with installation.${Reset}"
        exit 1
        ;;
    esac
}

# Main script execution

os_type=$(detect_os)

create_symlink "$os_type"

echo -e "${Blue}Starting dotfiles setup...${Reset}"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${Blue}Detected OS Type: Linux${Reset}"
    if [ -f /etc/arch-release ]; then
        echo -e "${Blue}Detected Distribution: Arch Linux${Reset}"
        arch_installation
    else
        echo -e "${Yellow}${DRY_RUN_PREFIX}Linux distribution not specifically supported for package installation by this script (e.g., not Arch). Symlinks created/checked.${Reset}"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${Blue}Detected OS type: MacOS${Reset}"
    create_symlink_macOS
    macOS_installation
else
    echo -e "${Red}❌ Unknown or unsupported OS type: $OSTYPE. Symlinks might have been created/checked, but package installation is skipped.${Reset}"
    # In dry run, we might not want to exit with 1 if it's just an unsupported OS for packages
    if [ ! "$DRY_RUN" = true ]; then
        exit 1
    fi
fi

echo -e "${Green}🎉 ${DRY_RUN_PREFIX}Dotfiles setup process complete! 🎉${Reset}"
if [ ! "$DRY_RUN" = true ]; then
    echo -e "${Yellow}Please restart your terminal or source your shell configuration (e.g., source ~/.zshrc) for changes to take effect.${Reset}"
fi

exit 0
