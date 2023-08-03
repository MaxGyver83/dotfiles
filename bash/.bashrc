# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

remove_from_path_if_symlink() {
    if [[ -L $1 ]] \
        && [[ $(realpath $1) == /usr/bin ]] \
        && [[ $PATH == *:$1:* || $PATH == $1:* ]] \
        && [[ $PATH == *:/usr/bin:* ]]
    then
        # remove $1 from middle of $PATH
        PATH="${PATH//:$1:/:}"
        # remove $1 from beginning of $PATH
        PATH="${PATH#$1:}"
    fi
}

prepend_to_path() {
    [ -d "$1" ] && [[ $PATH != *$1* ]] && PATH="$1:$PATH"
}

remove_from_path_if_symlink /sbin
remove_from_path_if_symlink /bin

prepend_to_path $HOME/.local/bin
prepend_to_path $HOME/install

exists() {
  command -v "$1" > /dev/null 2>&1 ;
}
exists luarocks && eval $(luarocks path)

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=10000

# Aufruf von forget löscht den letzten History-Eintrag
forget() {
   echo "Deleting line $(expr $( history | tail -n 1 | grep -oP '^ *\d+' ) - 1) from history"
   history -d $(expr $( history | tail -n 1 | grep -oP '^ *\d+' ) - 1);
}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# better colors for the virtual console (tty)
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0232323" #black
    echo -en "\e]P82B2B2B" #darkgrey
    echo -en "\e]P1D75F5F" #darkred
    echo -en "\e]P9E33636" #red
    echo -en "\e]P287AF5F" #darkgreen
    echo -en "\e]PA98E34D" #green
    echo -en "\e]P3D7AF87" #brown
    echo -en "\e]PBFFD75F" #yellow
    echo -en "\e]P48787AF" #darkblue
    echo -en "\e]PC7373C9" #blue
    echo -en "\e]P5BD53A5" #darkmagenta
    echo -en "\e]PDD633B2" #magenta
    echo -en "\e]P65FAFAF" #darkcyan
    echo -en "\e]PE44C9C9" #cyan
    echo -en "\e]P7E5E5E5" #lightgrey
    echo -en "\e]PFFFFFFF" #white
    clear #for background artifacting
fi

if [ -f ~/.bash_prompt ]; then
    source ~/.bash_prompt
elif [ -f ~/.dotfiles/bash/.bash_prompt ]; then
    source ~/.dotfiles/bash/.bash_prompt
else
    PS1="\n\u@\h:\w \$ "
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# default settings for less
export LESS='-iMFXRj4a#4'

# colored man pages
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[0;43;30m'  # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

export EDITOR=vim

export HOST="${HOST:-"$(hostname)"}"
case "$HOST" in
  LE-*) MACHINE=work/station ;;
  LR-*) MACHINE=work/laptop ;;
  max*) MACHINE=home/laptop ;;
  *pi1) MACHINE=home/raspi1 ;;
  *pi3) MACHINE=home/raspi3 ;;
  *gen) MACHINE=ionos/vps ;;
  *)    MACHINE="$HOST" ;;
esac
export MACHINE

export ABDUCO_CMD=fish

# use locate to find a file in home directory and highlight matches
locateh() {
  # case sensitive
  locate ${HOME}/\*"$1"\* | grep "${1/\*/.\*}"
}

locatehi() {
  # case insensitive
  locate -i ${HOME}/\*"$1"\* | grep -i "${1/\*/.\*}"
}

# mkdir and cd into it
mkcd() { mkdir -p -- "$1" && cd -P -- "$1" ; }

# copy ~/.vimrc to /tmp/.vimrc of host before ssh into it
vssh() {
  scp ~/.vimrc $1:/tmp/.vimrc
  ssh $1
}

tere() {
  local result=$(~/.local/bin/tere "$@")
  [ -n "$result" ] && cd -- "$result"
}

[ -f ~/workspace/z/z.sh ] && source ~/workspace/z/z.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# also find hidden files with FZF
#export FZF_DEFAULT_COMMAND="find ."
# better: use fd instead of find
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# use same command for Ctrl-t
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# use similar command for Alt-C
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--exact --color fg:-1,bg:-1,hl:#fa9a2d,fg+:3,hl+:#fa9a2d,info:150,prompt:110,spinner:150,pointer:167,marker:174"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --line-range :60 --color=always {}'"

# disable terminal freeze "scroll lock" with Ctrl-s (unlocking with Ctrl-q btw.)
stty -ixon

if [ -f ~/.bash_local ]; then
    source ~/.bash_local
fi
