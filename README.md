All files included in this folder.

Install PowerLine font Roboto: click on each .tiff file and click install.

Move jpro-minimal.zsh-theme into ~/.oh-my-zsh/themes/ directory.
In ~/.zshrc file change line ZSH_THEME="" to ZSH_THEME="jpro-minimal".

At the top of .zshrc file add line: neofetch.

Then go to: iTerm > Preferences > Profiles > Colors > Color Presets ... and
pick Flowerish.itermcolors.

Install autocomplete: sudo git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

Once that is done, add the plugin in the ~/.zshrc file's plugin list.

plugins=(
	...
	zsh-autosuggestions
)