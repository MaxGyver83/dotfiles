#!/usr/bin/env bash

# get directory of this script
VOU_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# activate "VOU" keyboard layout
xkbcomp -w 0 $VOU_DIR/vou.xkb $DISPLAY && echo -e '\nVOU keyboard layout activated.' || exit 1
unset VOU_DIR

# reset layout to QWERTZ by typing `asdf<Return>`
alias caei='setxkbmap de'
echo 'Type "asdf" (="caei") for setting the QWERTZ layout!'

# add alias for resetting to ~/.bash_aliases or ~/.bashrc (only use ~/.bash_aliases if it exists and it's being loaded in ~/.bashrc)
test -f ~/.bash_aliases && test -f ~/.bashrc && grep -q '\.bash_aliases' ~/.bashrc && CONFIG_FILE=~/.bash_aliases || CONFIG_FILE=~/.bashrc
grep -q "alias caei='setxkbmap de'" $CONFIG_FILE || echo -e "\n# alias added temporarily by schimax\nalias caei='setxkbmap de'" >> $CONFIG_FILE
unset CONFIG_FILE
