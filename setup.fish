echo "Setting up omf..."
omf install bass
omf install nvm
omf theme pseudobun
echo "Finished omf setup."
echo "Setting up pyenv..."
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
echo "Finished pyenv setup."
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"