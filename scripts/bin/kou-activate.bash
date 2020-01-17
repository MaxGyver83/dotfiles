#!/usr/bin/env bash

# activate kou keyboard layout
xkbcomp kou.xkb $DISPLAY

# reset layout to QWERTZ by typing `asdf<Return>`
alias haei='setxkbmap de'

# add alias for resetting to ~/.bash_aliases
grep -q "alias haei='setxkbmap de'" ~/.bash_aliases || echo -e "\n# alias added temporarily by schimax\nalias haei='setxkbmap de'" >> ~/.bash_aliases
