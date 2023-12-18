#!/bin/bash

dotfiles_path=~/.dotfiles

setup_gpg() {
    echo "Setting up GPG..."
    [ ! -d ~/.gnupg ] && mkdir ~/.gnupg && echo "Created ~/.gnupg folder."

    echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    echo 'use-agent' >> ~/.gnupg/gpg.conf
    echo "Finished setting up GPG."
}

install_xcode_tools() {
    command -v xcode-select &>/dev/null && echo "Xcode CLI is already installed. Consider updating it manually..." && return
    echo "Xcode CLI is not installed, do you want to install it? (y/n): "
    read -r xcode

    if [ "$xcode" == "y" ] || [ -z "$xcode" ]; then
        xcode-select --install && echo "Xcode CLI installed."
    else
        echo "Xcode CLI is required for this script to work. Exiting..." && exit 1
    fi
}

clone_dotfiles_repo() {
    echo "Preparing to clone dotfiles repo..."
    echo "Enter the path where to clone the repo (default: $dotfiles_path): "
    read user_input
    if [ -n "$user_input" ]; then
        dotfiles_path=$user_input
    fi
    echo "Cloning dotfiles repo to $dotfiles_path..."
    # git clone https://github.com/pseudobun/dotfiles.git $dotfiles_path
    echo "Finished cloning dotfiles repo."
    cd $dotfiles_path
    echo "Executing in: $(pwd)"
}

manage_homebrew() {
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && echo "Homebrew installed."
    else
        brew update && brew upgrade && echo "Homebrew updated."
    fi
    brew bundle --file ./Brewfile && echo "Homebrew packages installed."
}

set_fish_shell() {
    [ "$SHELL" == "$(which fish)" ] && echo "Fish shell is already set as the default shell." && return
    echo "Do you want to set fish as default shell? (y/n): "
    read -r fish

    if [[ "$fish" == "y" ]] || [[ -z "$fish" ]]; then
        echo "$(which fish)" | sudo tee -a /etc/shells
        chsh -s "$(which fish)" && echo "Fish set as default shell."
    fi
}

install_omf() {
    echo "Installing omf (Oh-My-Fish)..."
    echo "(EXPERIMENTAL) - Do you want to install omf (Oh-My-Fish)? (y/n): "
    read -r omf
    [[ "$omf" == "y" ]] || [[ -z "$omf" ]] && curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    echo "Finished installing omf."
}

setup_nvm() {
    nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh"
    echo "Install NVM from (default: $nvm_url): "
    read -r nvm_alt_url
    [ -n "$nvm_alt_url" ] && nvm_url=$nvm_alt_url
    curl -o- $nvm_url | bash
}

symlink_dotfiles() {
    echo "Symlinking dotfiles..."
    ln -fs $dotfiles_path/.gitconfig ~/.gitconfig
    ln -fs $dotfiles_path/functions/* ~/.config/fish/functions/
    ln -fs $dotfiles_path/macchina/pseudobun.toml ~/.config/macchina/themes
    ln -fs $dotfiles_path/pseudobun.fish ~/.config/fish
    ln -fs $dotfiles_path/yabai/.yabairc ~/.yabairc
    ln -fs $dotfiles_path/yabai/.skhdrc ~/.skhdrc
    echo "Finished symlinking dotfiles."
}

install_rust() {
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    echo "Finished installing Rust."
}

install_bun() {
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
    echo "Finished installing Bun."
}

setup_macos_defaults() {
    echo "Setting up MacOS defaults..."
    defaults write .GlobalPreferences com.apple.mouse.scaling -1
    defaults write com.apple.dock autohide-time-modifier -float 0.05
    defaults write com.apple.dock "scroll-to-open" -bool "true"
    echo "Finished setting up MacOS defaults."
}

main() {
    install_xcode_tools
    clone_dotfiles_repo
    manage_homebrew
    set_fish_shell
    install_omf
    setup_nvm
    setup_gpg
    symlink_dotfiles
    fish ./setup.fish
    install_rust
    install_bun
    setup_macos_defaults
    fish 

    echo "Finished setting up pseudobun's dotfiles."
}

main "$@"