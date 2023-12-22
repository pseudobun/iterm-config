#!/bin/bash

dotfiles_path=~/.dotfiles

setup_gpg() {
    echo "Setting up GPG..."
    [ ! -d ~/.gnupg ] && mkdir ~/.gnupg && echo "Created ~/.gnupg folder."

    echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    echo 'use-agent' >> ~/.gnupg/gpg.conf
    echo "no-emit-version" >> ~/.gnupg/gpg.conf
    echo "default-key 7A5C62926461D990A0575C9EA03490EFF21E32E9" >> ~/.gnupg/gpg.conf
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

install_kitty() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
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
    [ -d "~/.config/fish/functions" ] || mkdir -p "~/.config/fish/functions"
    ln -fs $dotfiles_path/functions/* ~/.config/fish/functions/

    [ -d "~/.config/macchina/themes" ] || mkdir -p "~/.config/macchina/themes"
    ln -fs $dotfiles_path/macchina/pseudobun.toml ~/.config/macchina/themes

    [ -d "~/.config/alacritty" ] || mkdir -p "~/.config/alacritty"
    ln -fs $dotfiles_path/alacritty/alacritty.yml ~/.config/alacritty

    [ -d "~/.config/sketchybar/plugins" ] || mkdir -p "~/.config/sketchybar/plugins"
    [ -d "~/.config/sketchybar/items" ] || mkdir -p "~/.config/sketchybar/items"
    ln -fs $dotfiles_path/sketchybar/* ~/.config/sketchybar

    [ -d "~/.config/fish" ] || mkdir -p "~/.config/fish"
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

install_appstore_apps() {
    # Dropover
    mas install 1355679052
    # Raivo OTP
    mas install 1498497896
    # Wireguard
    mas install 1451685025
    # Magnet
    mas install 441258766
    # Reeder
    mas install 1529448980
}

install_spicetify() {
    echo "Installing Spicetify..."
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
    curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-marketplace/main/resources/install.sh | sh
    echo "Finished installing Spicetify."
}

setup_macos_defaults() {
    echo "Setting up MacOS defaults..."
    defaults write .GlobalPreferences com.apple.mouse.scaling -1
    defaults write com.apple.dock autohide-time-modifier -float 0.05
    defaults write com.apple.dock "scroll-to-open" -bool "true"
    echo "Finished setting up MacOS defaults."
}

start_services() {
    brew services start sketchybar
    yabai --stop-service
    skhd --stop-service
    yabai --install-service
    skhd --install-service
    spicetify apply

    echo "yabai and skhd services have been installed. remember to edit the .plist files to change default shell to /bin/sh, see: https://gist.github.com/pseudobun/34c42b0bf20e82f114fd232c8ce55fe2"
}

auth_gh() {
    gh auth login
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
    install_spicetify
    setup_macos_defaults
    install_kitty
    install_appstore_apps
    auth_gh
    start_services
    echo "Finished setting up pseudobun's dotfiles."
    echo "Make sure everything is ok and reboot your Mac."
    fish
}

main "$@"