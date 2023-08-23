#!/bin/bash
if ! command -v xcode-select &>/dev/null; then
    echo "Xcode CLI is not installed, do you want to install it? (y/n): "
    read xcode
    if [ "$xcode" == "y" ] || [ -z "$xcode" ]; then
        echo "Installing Xcode CLI..."
        xcode-select --install
        echo "Xcode CLI installed."
    else
        echo "Xcode CLI is required for this script to work. Exiting..."
        exit 1
    fi
else
    echo "Xcode CLI is already installed. Consider updating it manually..."
fi

echo "Preparing to clone dotfiles repo..."
echo "Enter the path where to clone the repo (default: ~/.dotfiles): "
read dotfiles_path

if [ -z "$dotfiles_path" ]; then
    dotfiles_path=~/.dotfiles
fi

echo "Cloning dotfiles repo to $dotfiles_path..."
git clone https://github.com/pseudobun/dotfiles.git ~/.dotfiles
echo "Finished cloning dotfiles repo."
cd $dotfiles_path
echo "Executing in: $(pwd)"

# check if homebrew is installed, if not install it, else update
if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed, installing it..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed."
else
    echo "Homebrew is already installed. Running brew upgrade..."
    brew update
    brew upgrade
    echo "Homebrew updated."
fi

echo "Installing packages from Brewfile..."
brew bundle --file ./Brewfile
echo "Homebrew packages installed."

if [ "$SHELL" == "$(which fish)" ]; then
    echo "Fish shell is already set as the default shell."
else
    echo "Do you want to set fish as default shell? (y/n): "
    read fish
    if [[ "$fish" == "y" ]] || [[ -z "$fish" ]]; then
        echo "Setting fish as default shell..."
        echo $(which fish) | sudo tee -a /etc/shells
        chsh -s $(which fish)
        echo "Fish set as default shell."
    fi
fi

echo "Installing omf (Oh-My-Fish)..."
# FIXME: omf installation in this script setup.fish is not working, hangs
echo "(EXPERIMENTAL) - Do you want to install omf (Oh-My-Fish)? (y/n): "
read omf
if [[ "$omf" == "y" ]] || [[ -z "$omf" ]]; then
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fi
echo "Finished installing omf."

# macchina config folder
mkdir -p ~/.config/macchina/themes
# fish config folder
mkdir -p ~/.config/fish
# omf config folder
mkdir -p ~/.local/share/omf/themes/pseudobun/functions

# symlinking dotfiles
echo "Symlinking dotfiles..."
ln -fs $dotfiles_path/.gitconfig ~/.gitconfig
ln -fs $dotfiles_path/functions/* ~/.local/share/omf/themes/pseudobun/functions
ln -fs $dotfiles_path/macchina/pseudobun.toml ~/.config/macchina/themes
ln -fs $dotfiles_path/pseudobun.fish ~/.config/fish
fish ./setup.fish

if ! grep -q "source ~/.config/fish/pseudobun.fish" ~/.config/fish/config.fish; then
    echo -e "\nsource ~/.config/fish/pseudobun.fish" | sudo tee -a ~/.config/fish/config.fish
fi
echo "Finished symlinking dotfiles."

# Install and set up up NVM
nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh"
echo "Install NVM from (default: $nvm_url): "
read nvm_alt_url
if [ -n "$nvm_alt_url" ]; then
    nvm_url=$nvm_alt_url
fi

curl -o- $nvm_url | bash
ln -fs $dotfiles_path/nvm.fish ~/.config/fish/functions

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "Finished installing Rust."

# At the end set the remote to the ssh version
git remote set-url origin git@github.com:pseudobun/dotfiles.git

echo "Finished setting up pseudobun's dotfiles."

# MacOS defaults
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write com.apple.dock "scroll-to-open" -bool "true"