#!/usr/bin/env bash

# when called with option -w, run this script in a new alacritty window
if [ $# -ge 1 ] && [ "$1" = "-w" ]; then
  pid=$(pgrep -f "alacritty -t 'Screenshot menu'")
  test -z $pid && WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Screenshot menu" -o "window.dimensions.columns=50" -o "window.dimensions.lines=10" -e "$0" || kill $pid
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

case $key in
  W) $SLEEP ; nohup scrot ~/Screenshots/"$FILENAME Screen.png" -e "$NOTIFICATION" & ;;
  A) $SLEEP ; nohup scrot -u ~/Screenshots/"$FILENAME Window.png" -e "$NOTIFICATION" & ;;
  S) $SLEEP ; nohup scrot -s ~/Screenshots/"$FILENAME Region.png" -e "$NOTIFICATION" & ;;
  a) $SLEEP ; nohup scrot -u /tmp/"$FILENAME Window.png" -e "copyq write image/png - < '\$f' && $NOTIFICATION" & ;;
  s) $SLEEP ; nohup scrot -s /tmp/"$FILENAME Region.png" -e "copyq write image/png - < '\$f' && $NOTIFICATION" & ;;
  o | O) $SLEEP ; ~/bin/ocr-region-to-clipboard.bash && notify-send "Copied to clipboard:" "$(xsel -bo)" ;;
  g) xclip -selection clipboard -t image/png -i "$(ls -t ~/Screenshots/*.png /tmp/20*.png | sxiv -ft -i -o)" ;;
  *) echo Canceled. ;;
esac
