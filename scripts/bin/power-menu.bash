#!/usr/bin/env bash

# when called with option -w, run this script in a new alacritty window
if [ $# -ge 1 ] && [ "$1" = "-w" ]; then
  pid=$(pgrep -f "alacritty -t 'Power menu'")
  test -z $pid && WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Power menu" -o "window.dimensions.columns=30" -o "window.dimensions.lines=8" -e "$0" || kill $pid
  exit 0
fi

options='
lock screen
kill dwm (=restart)
exit dwm (logout)
reboot
shutdown
'

# print first letter in red at the beginning of each line
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
options=$(echo "$options" | sed -e "s/\(^.\)/${red}${bold}\1${normal} \1/")

echo -e "Select an option:\n$options"
read -rsn1 key

case $key in
  l) png="$(xdg-user-dir PICTURES)/Leo4.png" && test -f "$png" && i3lock -n -e -f -i "$png" -t || i3lock -n -e -f -c 333333 ;;
  k) pkill -f '^dwm' ;;
  e) pkill dwm ;;
  r) systemctl reboot ;;
  s) systemctl poweroff ;;
  *) echo Canceled. ;;
esac
