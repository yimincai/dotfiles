# List of files to symlink
files=(
  ".vimrc"
  ".zshrc"
  ".zshenv"
  ".tmux.conf"
  ".tmux.conf.bak"
  ".gitconfig"
  ".gitignore"
  ".ideavimrc"
  ".nvimrc"
)

# Create symlinks and backup existing files
for file in "${files[@]}"
do
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

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
  echo "Homebrew could not be found, installing..."
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed, skipping..."
fi

# Install required packages
brew_packages=("git" "tmux" "neovim" "fzf" "zsh" "zplug")
for package in "${brew_packages[@]}"
do
  if ! brew list "$package" &>/dev/null; then
    echo "Installing $package..."
    brew install "$package"
  else
    echo "$package is already installed, skipping..."
  fi
done

# Ask user to install powerlevel10k
echo "Do you want to install powerlevel10k? (y/n)"
read answer
if echo "$answer" | grep -iq "^y" ;then
  echo "Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
  echo "Skipping powerlevel10k installation..."
fi

