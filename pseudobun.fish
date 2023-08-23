set -g fish_greeting

zoxide init fish | source

abbr -a htop 'btm'
abbr -a top 'btm'
abbr -a ls 'exa --icons'
abbr -a cd 'z'

alias please='sudo'
alias launchtsm='osascript $HOME/.dotfiles/transmission_lift.osascript'
alias tsm='transmission-remote'
alias watchtsm="watch --interval 1 'transmission-remote -l'"

function cs
   z $argv
   exa -ahl --icons
end

macchina -t pseudobun
