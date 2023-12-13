#!/bin/bash

# Check system type
if [ "$(uname)" == "Darwin" ]; then
  # macOS
  package_manager="brew"
  install_command="brew install"
  uninstall_command="brew uninstall"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  package_manager="apt"
  install_command="sudo apt-get install -y"
  uninstall_command="sudo apt-get remove -y"
else
  echo "Unsupported operating system."
  exit 1
fi

# List of files to symlink
files=(
  ".vimrc"
  ".zshrc"
  ".zshenv"
  ".tmux.conf"
  ".gitconfig"
  ".gitignore"
  ".ideavimrc"
  ".nvimrc"
)

# Symlink and backup existing files
for file in "${files[@]}"; do
  target="$HOME/$file"
  backup="$target.bak"

  # Check if the file exists
  if [ -e "$target" ]; then
    # Backup existing file
    echo "Backing up existing $file to $backup"
    mv "$target" "$backup"
  fi

  # Create symlink
  echo "Creating symlink for $file"
  ln -s "$HOME/.dotfiles/$file" "$target"
done

# Create symlink for nvim config directory
nvim_config_dir="$HOME/.config/nvim"
if [ ! -e "$nvim_config_dir" ]; then
  echo "Creating symlink for nvim config directory"
  ln -s "$HOME/.dotfiles/nvim" "$nvim_config_dir"
fi

# Install/Uninstall required packages
packages=("git" "tmux" "neovim" "fzf" "zsh")
for package in "${packages[@]}"; do
  if command -v "$package" &>/dev/null; then
    echo "$package is already installed, skipping..."
  else
    echo "Installing $package..."
    $install_command "$package"
  fi
done
