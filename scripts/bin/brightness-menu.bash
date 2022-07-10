#!/usr/bin/env bash

# when called with option -w, run this script in a new alacritty window
if [ $# -ge 1 ] && [ "$1" = "-w" ]; then
  pid=$(pgrep -f "alacritty -t 'Brightness menu'")
  test -z $pid && WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Brightness menu" -o "window.dimensions.columns=20" -o "window.dimensions.lines=11" -e "$0" || kill $pid
  exit 0
fi

options='
1 100 %
9 90 %
8 80 %
7 70 %
6 60 %
5 50 %
4 40 %
3 30 %
r redshift
n no redshift
'

# print first letter of each line in red
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
options=$(echo "$options" | sed -e "s/\(^.\)/${red}${bold}\1${normal}/")

echo -e "Select an option:\n$options"
read -rsn1 key

case $key in
  [3-9]) ~/bin/brightness $key ;;
  1) ~/bin/brightness max ;;
  r) redshift -P -O 3500 -b 0.7 ;;
  n) redshift -P -O 6500 ;;
  *) echo Canceled. ; exit 1 ;;
esac
