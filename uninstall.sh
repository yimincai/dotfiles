#!/bin/bash

# Check system type
if [ "$(uname)" == "Darwin" ]; then
  # macOS
  uninstall_command="brew uninstall"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  uninstall_command="sudo apt-get remove -y"
else
  echo "Unsupported operating system."
  exit 1
fi

# List of files to uninstall and restore from backup
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

# Uninstall packages
packages=("git" "tmux" "neovim" "fzf" "zsh")
for package in "${packages[@]}"; do
  if command -v "$package" &>/dev/null; then
    echo "Uninstalling $package..."
    $uninstall_command "$package"
  else
    echo "$package is not installed, skipping uninstallation..."
  fi
done

# Restore files from backup and remove symlinks
for file in "${files[@]}"; do
  target="$HOME/$file"
  backup="$target.bak"

  # Check if a backup exists
  if [ -e "$backup" ]; then
    # Restore the backup
    echo "Restoring $file from backup"
    mv "$backup" "$target"
  fi

  # Remove symlink
  if [ -L "$target" ]; then
    echo "Removing symlink for $file"
    rm "$target"
  fi
done

# Remove symlink for nvim config directory
nvim_config_dir="$HOME/.config/nvim"
if [ -L "$nvim_config_dir" ]; then
  echo "Removing symlink for nvim config directory"
  rm "$nvim_config_dir"
fi
