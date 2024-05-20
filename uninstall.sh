#!/bin/bash

#TODO: Fix Ubuntu not working due to zplug install, permission denied, packer errors etc.

# List of files to uninstall and restore from backup
files=(
  ".vimrc"
  ".zshrc"
  ".tmux.conf"
  ".gitconfig"
  ".gitignore"
  ".ideavimrc"
  ".nvimrc"
)

# Uninstall Homebrew packages
brew_packages=("git" "tmux" "neovim" "fzf" "zsh" "zplug")
for package in "${brew_packages[@]}"
do
  if brew list "$package" &>/dev/null; then
    echo "Uninstalling $package..."
    brew uninstall "$package"
  else
    echo "$package is not installed, skipping uninstallation..."
  fi
done

# Restore files from backup and remove symlinks
for file in "${files[@]}"
do
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

# Remove powerlevel10k if installed
powerlevel10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$powerlevel10k_dir" ]; then
  echo "Removing powerlevel10k..."
  rm -rf "$powerlevel10k_dir"
fi

