#                 _  _
#                (_)(_)
#   _   _  _   _  _  _  _ __   _   _  _   _  ____
#  | | | || | | || || || '_ \ | | | || | | ||_  /
#  | |_| || |_| || || || | | || |_| || |_| | / /
#   \__, | \__,_|| ||_||_| |_| \__, | \__,_|/___|
#    __/ |      _/ |            __/ |
#   |___/      |__/            |___/
#
#   Author: yujinyuz
#   GitHub: https://github.com/yujinyuz
#   Twitter: https://twitter.com/yujinyuz_
# JPro Minimal Theme

_collapsed_wd() {
  echo $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

PROMPT_SYMBOL="$"

PROMPT='%{$fg[cyan]%}%n%{$reset_color%} \
[%{$FG[010]%}$(_collapsed_wd)%{$reset_color%}] \
$(git_prompt_info)\
%{$fg[green]%}$PROMPT_SYMBOL '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%} %{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""
