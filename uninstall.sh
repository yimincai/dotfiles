#!/bin/bash

Green='\033[0;32m'
Red='\033[0;31m'
Blue='\033[1;34m'
Yellow='\033[0;33m'
Reset='\033[0m'

# List of files to remove symlink and restore backups
files=(
	".vimrc"
	".zshrc"
	".zshenv"
	".tmux.conf"
	".tmux"
	".gitconfig"
	".gitignore"
	".ideavimrc"
)

# List of files in the .config directory to remove symlink and restore backups
files_in_config_folder=(
	".config/alacritty"
	".config/borders"
	".config/kitty"
	".config/nvim"
	".config/scripts"
	".config/sketchybar"
	".config/skhd"
	".config/yabai"
)

MacOS_uninstallation() {
	# Remove symlinks and restore backups
	for file in "${files[@]}"; do
		target="$HOME/$file"
		backup="$target.bak"

		# Remove symlink if exists
		if [ -L "$target" ]; then
			echo -e "${Yellow}Removing symlink for $file${Reset}"
			rm "$target"
		fi

		# Restore backup if exists
		if [ -e "$backup" ]; then
			echo -e "${Green}Restoring backup for $file${Reset}"
			mv "$backup" "$target"
		fi
	done

	# Remove symlink for config directory and restore backups
	for file in "${files_in_config_folder[@]}"; do
		target="$HOME/$file"
		backup="$target.bak"

		# Remove symlink if exists
		if [ -L "$target" ]; then
			echo -e "${Yellow}Removing symlink for $file${Reset}"
			rm "$target"
		fi

		# Restore backup if exists
		if [ -e "$backup" ]; then
			echo -e "${Green}Restoring backup for $file${Reset}"
			mv "$backup" "$target"
		fi
	done

	# Uninstall Homebrew packages if needed
	brew_packages=(
		"font-hack-nerd-font"
		"wget"
		"zsh"
		"tmux"
		"neovim"
		"git"
		"alacritty"
		"kitty"
		"koekeishiya/formulae/yabai"
		"koekeishiya/formulae/skhd"
		"sketchybar"
		"neofetch"
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
		"youtube-dl"
		"zplug"
	)

	for package in "${brew_packages[@]}"; do
		if brew list "$package" &>/dev/null; then
			echo -e "${Green}Uninstalling $package...${Reset}"
			brew uninstall "$package"
		else
			echo -e "${Yellow}$package is not installed, skipping...${Reset}"
		fi
	done

	echo -e "$Blue}DONE!${Reset}"
}

# detect OS type
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo -e "${Blue}Detected OS Type: Linux${Reset}"
	echo -e "${Red}Not implemented${Reset}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo -e "${Blue}Detected OS type: MacOS${Reset}"
	MacOS_uninstallation
else
	echo -e "${Red}Unknown OS type or not supported${Reset}"
fi
