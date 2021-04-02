#!/usr/bin/env bash

# when called with option -w, run this script in a new alacritty window
if [ $# -ge 1 ] && [ "$1" = "-w" ]; then
  pid=$(pgrep -f "alacritty -t 'Screenshot menu'")
  test -z $pid && WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Screenshot menu" -o "window.dimensions.columns=50" -o "window.dimensions.lines=11" -e "$0" >> ~/log/screenshot-menu.log 2>&1 || kill $pid
  exit 0
fi

SLEEP='sleep 0.2'
NOTIFICATION='echo "$f" && notify-send -u low "$f"'
FILENAME='%Y-%m-%d %H.%M.%S $wx$h'

options='
Whole screen
Active window
Selected region
active window (/tmp + clipboard)
selected region or window (/tmp + clipboard)
OCR region (to clipboard)
gallery of screenshots: Select one to be copied to clipboard (`mq`)
'

# print first letter in red at the beginning of each line
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
options=$(echo "$options" | sed -e "s/\(^.\)/${red}${bold}\1${normal} \1/")

echo -e "Select an option:\n$options"
read -rsn1 key

sleep 0.1

case $key in
  W) nohup ~/bin/screenshot.bash & ;;
  A) nohup ~/bin/screenshot.bash -w & ;;
  S) nohup ~/bin/screenshot.bash -r & ;;
  a) nohup ~/bin/screenshot.bash -w -c & ;;
  s) nohup ~/bin/screenshot.bash -r -c & ;;
  o | O) nohup ~/bin/screenshot.bash -o & ;;
  g) nohup ~/bin/screenshot.bash -g & ;;
  *) echo Canceled. > /tmp/nohup.out ;;
esac
