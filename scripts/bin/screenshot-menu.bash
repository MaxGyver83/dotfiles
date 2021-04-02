#!/usr/bin/env bash

# when called with option -w, run this script in a new alacritty window
if [ $# -ge 1 ] && [ "$1" = "-w" ]; then
  pid=$(pgrep -f "alacritty -t 'Screenshot menu'")
  test -z $pid && WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Screenshot menu" -o "window.dimensions.columns=50" -o "window.dimensions.lines=11" -e "$0" >> ~/log/screenshot-menu.log 2>&1 || kill $pid
  exit 0
fi

options='
S All screen
W Active window
R Select region
s All screens
w Active window (/tmp + clipboard)
r Select region or window (/tmp + clipboard)
o OCR region (to clipboard)
g Gallery of screenshots: Select one to be copied to clipboard (`mq`)
'

# print first letter of each line bold and in red
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
options=$(echo "$options" | sed -e "s/\(^.\)/${red}${bold}\1${normal}/")

echo -e "Select an option:\n$options"
read -rsn1 key

case $key in
  S|W|R) nohup ~/bin/screenshot.bash -${key,,} & ;;
  s|w|r) nohup ~/bin/screenshot.bash -$key -c & ;;
  o|O) nohup ~/bin/screenshot.bash -o & ;;
  g) nohup ~/bin/screenshot.bash -g & ;;
  *) echo Canceled. > /tmp/nohup.out ;;
esac

sleep 0.1
