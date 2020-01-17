#!/usr/bin/env bash

# get directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# activate kou keyboard layout
xkbcomp -w 0 $DIR/kou.xkb $DISPLAY && echo -e '\nKOU keyboard layout activated.' || exit 1

# reset layout to QWERTZ by typing `asdf<Return>`
alias haei='setxkbmap de'
echo 'Type "asdf" (="haei") for setting the QWERTZ layout!'

# add alias for resetting to ~/.bash_aliases
grep -q "alias haei='setxkbmap de'" ~/.bash_aliases || echo -e "\n# alias added temporarily by schimax\nalias haei='setxkbmap de'" >> ~/.bash_aliases
