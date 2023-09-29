set -g fish_greeting
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set --export GPG_TTY $(tty)

pyenv init - | source
zoxide init fish | source
starship init fish | source

abbr -a htop 'btm'
abbr -a top 'btm'
abbr -a ls 'exa --icons'
abbr -a cd 'z'
abbr -a l 'exa -ahl --icons'

alias please='sudo'
alias launchtsm='osascript $HOME/.dotfiles/transmission_lift.osascript'
alias tsm='transmission-remote'
alias watchtsm="watch --interval 1 'transmission-remote -l'"

fish_add_path ~/.cargo/bin

load_nvm > /dev/stderr

function cs
   z $argv
   exa -ahl --icons
end

macchina -t pseudobun
