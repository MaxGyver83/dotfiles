# load aliases
if [ -f $HOME/.config/fish/aliases.fish ]
  source $HOME/.config/fish/aliases.fish
end

# no greeting
set -U fish_greeting ""

# don't shorten path in prompt
set -U fish_prompt_pwd_dir_length 0

# bright blue working directory in prompt
set fish_color_cwd brblue

set -g __fish_git_prompt_color_branch
set -g __fish_git_prompt_showcolorhints true
# set -g __fish_git_prompt_char_upstream_ahead "↑ "
# set -g __fish_git_prompt_char_upstream_behind "↓ "
# set -g __fish_git_prompt_char_upstream_prefix ""
# set -g __fish_git_prompt_char_stagedstate "● "
# set -g __fish_git_prompt_char_dirtystate "✚ "
# set -g __fish_git_prompt_char_untrackedfiles "…"
# set -g __fish_git_prompt_char_invalidstate "✖ "
# set -g __fish_git_prompt_char_cleanstate "✔ "
# Extra space not necessary, better change terminal font to Monospace Regular, 14.

# colored man pages
set -x LESS_TERMCAP_mb (printf "\033[1;31m")     # begin bold
set -x LESS_TERMCAP_md (printf "\033[1;36m")     # begin blink
set -x LESS_TERMCAP_me (printf "\033[0m")        # reset bold/blink
set -x LESS_TERMCAP_so (printf "\033[01;44;33m") # begin reverse video
set -x LESS_TERMCAP_se (printf "\033[0m")        # reset reverse video
set -x LESS_TERMCAP_us (printf "\033[1;32m")     # begin underline
set -x LESS_TERMCAP_ue (printf "\033[0m")        # reset underline
set -x GROFF_NO_SGR 1                            # for konsole and gnome-terminal

# use vim for editing the command line with Alt-e
set -x VISUAL vim

# also find hidden files with FZF
#set -x FZF_DEFAULT_COMMAND "find ."
# better: use fd instead of find
set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
# use same command for Ctrl-t
set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND' --search-path $dir'
# use similar command for Alt-C
set -x FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
set -x FZF_DEFAULT_OPTS "--exact"
set -x FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --line-range :60 --color=always {}'"

