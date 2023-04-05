## Personal configuration for iTerm2

This repository contains configuration files and images for my personal workspace (iTerm config and desktop wallpapers). Wallpaper assets used have been downloaded from the [Ethereum's official Assets site](https://ethereum.org/en/assets/).

> *Note: all required files are included in this repo.*

### 1. Install PowerLine font Roboto or JetBrains Mono, which one you prefer
- Click on each `.tiff` file and click install.

### 2. Move the included theme to oh-my-zsh themes director
- `mv ./jpro-minimal.zsh-theme ~/.oh-my-zsh/themes/`

### 3. Update .zshrc file
- Open `~/.zshrc` file in your favorite text editor
- Change the line `ZSH_THEME="" to ZSH_THEME="jpro-minimal"`
- Optional:
	If you'd like to print all data regarding your computer at the beginning of each session you can use [`neofetch`](https://github.com/dylanaraps/neofetch). Just install it with `brew install neofetch` and add the line `neofetch` at the top of `.zshrc` file.

### 4. Set colors
- Open iTerm2 and go to `iTerm > Preferences > Profiles > Colors > Color Presets ...` and pick `Flowerish.itermcolors`

### 5. Import key bindings and profile
- Open iTerm2 and go to `iTerm > Preferences > Profiles > Other actions ... > Import JSON profiles ...` and pick `custom_profile.json`
- Go to `iTerm > Preferences > Keys > Key Bindings > Presets ... > Import ...` and pick `key_bindings_config.itermkeymap`

### 6. Optional: Install autocomplete
- Run `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
- Add the installed plugin to the list of plugins in `.zshrc` file:
```
plugins=(
	...
	zsh-autosuggestions
)
```

### Configuration in action:
![iTerm2 Appearance](iterm2.png)
