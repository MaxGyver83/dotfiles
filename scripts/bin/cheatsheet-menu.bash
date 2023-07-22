#!/usr/bin/env bash

SCRIPT=~/bin/cheatsheet.bash
CHEATSHEET_DIR=~/.dotfiles/cheatsheets

# when called with option -w, run this script in a new alacritty window
if [ "$1" = "-w" ]; then
  pkill -f "alacritty -t Cheatsheet" || \
  WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Cheatsheet menu" \
    -o "window.dimensions.columns=18" -o "window.dimensions.lines=7" \
    -o "font.size=16.0" -o "colors.primary.background='#fcfc90'" \
    -o "colors.primary.foreground='#000000'" -e "$0"
  exit 0
fi

options='
vim
tmux
aerc
misc
'

# print first letter in red at the beginning of each line
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
options=$(echo "$options" | sed -e "s/\(^.\)/${red}${bold}\1${normal} \1/")

echo -e "Show cheatsheet:\n$options" | sed 's/^/ /'
read -rsn1 key

case $key in
  v) nohup $SCRIPT $CHEATSHEET_DIR/vim.txt & ;;
  t) nohup $SCRIPT $CHEATSHEET_DIR/tmux.txt & ;;
  a) nohup $SCRIPT $CHEATSHEET_DIR/aerc.txt & ;;
  m) nohup $SCRIPT $CHEATSHEET_DIR/misc.txt & ;;
  *) echo Canceled. ;;
esac
