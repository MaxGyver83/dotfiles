#!/usr/bin/env bash

SCRIPT=~/bin/cheatsheet.bash
CHEATSHEET_DIR=~/.dotfiles/cheatsheets

options="$(ls -1 $CHEATSHEET_DIR | grep \\.txt | sed s/\.txt//)"

lines="$(echo "$options" | wc -l)"
lines=$((lines + 2))

# when called with option -w, run this script in a new alacritty window
if [ "$1" = "-w" ]; then
  if [ "$2" != "-v" ]; then
    export YELLOW="-o colors.primary.background='#fcfc90' \
                   -o colors.primary.foreground='#000000'"
    export USE_LESS=1
  fi
  pkill -f "alacritty -t Cheatsheet" || \
  WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Cheatsheet menu" \
    -o "window.dimensions.columns=18" -o "window.dimensions.lines=$lines" \
    -o "font.size=14.0" $YELLOW -e "$0"
  exit 0
fi

# print first letter in red at the beginning of each line
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
options=$(echo "$options" | sed -e "s/\(^.\)/${red}${bold}\1${normal} \1/")

echo -e "Show cheatsheet:\n$options" | sed 's/^/ /'
read -rsn1 key

case "$key" in
$'\e'|""|"\t"|"\n") echo "Cancel."; sleep 0.5; exit 1 ;;
esac

# show cheatsheet beginning with entered letter
glob="$CHEATSHEET_DIR/$key*.txt"
if ls $glob &>/dev/null; then
  nohup $SCRIPT $glob &
  sleep 0.1
else
  echo "No cheatsheet found starting with '$key'!"
  sleep 1
fi
