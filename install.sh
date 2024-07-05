#!/bin/bash

Green='\033[0;32m'
Red='\033[0;31m'
Blue='\033[1;34m'
Yellow='\033[0;33m'
Reset='\033[0m'

# List of files to symlink
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

# List of files in the .config directory to symlink
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

MacOS_instalation() {
	# Create symlinks and backup existing files
	for file in "${files[@]}"; do
		target="$HOME/$file"
		backup="$target.bak"

		# Check if the file exists
		if [ -e "$target" ]; then
			# Backup existing file
			echo -e "${Yellow}Backing up existing $file to $backup${Reset}"
			mv "$target" "$backup"
		fi

		# Create symlink
		echo -e "${Green}Creating symlink for $file${Reset}"
		ln -s "$(pwd)/$file" "$target"
	done

	# Create symlink for config directory
	for file in "${files_in_config_folder[@]}"; do
		target="$HOME/$file"
		backup="$target.bak"

		# Check if the file exists
		if [ -e "$target" ]; then
			# Backup existing file
			if [ -e "$backup" ]; then
				echo -e "${Red}Removing existing backup $backup${Reset}"
				rm -rf "$backup"
			fi
			echo -e "${Yellow}Backing up existing $file to $backup${Reset}"
			mv "$target" "$backup"
		fi

		# Create symlink
		echo -e "${Green}Creating symlink for $file${Reset}"
		ln -s "$(pwd)/$file" "$target"
	done

	# Check if Homebrew is installed
	if ! command -v brew &>/dev/null; then
		echo -e "${Yellow}Homebrew could not be found, installing...${Reset}"
		# Install Homebrew
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		echo -e "${Green}Homebrew is already installed, skipping...${Reset}"
	fi

	# add brew tap
	brew tap FelixKratz/formulae

	# Install required packages
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
		"zplug"
	)

	for package in "${brew_packages[@]}"; do
		if ! brew list "$package" &>/dev/null; then
			echo -e "${Green}Installing $package...${Reset}"
			brew install "$package"
		else
			echo -e "${Yellow}$package is already installed, skipping...${Reset}"
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
	MacOS_instalation
else
	echo -e "${Red}Unknown OS type or no supported${Reset}"
fi
