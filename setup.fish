echo "Setting up omf..."
omf install bass
omf install https://github.com/fabioantunes/fish-nvm
omf theme pseudobun
echo "Finished omf setup."
echo "Setting up pyenv..."
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
fish_add_path /opt/homebrew/opt/postgresql@15/bin
fish_add_path ~/.cargo/bin
echo "Finished pyenv setup."