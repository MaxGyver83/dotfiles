#!/usr/bin/env bash

show_help() {
  echo "Arguments:
  -c|--clipboard   Save screenshot in /tmp and copy into clipboard
  -s|--screen      Take screenshot of all screens
  -w|--window      Take screenshot of active window
  -r|--region      Select region for screenshot
  -o|--ocr         Select region, do OCR and copy recognized text to clipboard
  -g|--gallery     Select a screenshot (from ~/Screenshots and /tmp) to copy into clipboard
"
}

while [[ "$#" > 0 ]]; do case $1 in
  -h|--help) show_help; exit 0;shift;;
  -c|--clipboard) CLIPBOARD=1;shift;;
  -s|--screen) PARAM=''  ; TYPE='Screen'; shift;;
  -w|--window) PARAM='-u'; TYPE='Window'; shift;;
  -r|--region) PARAM='-s'; TYPE='Region'; shift;;
  -o|--ocr) OCR=1;shift;;
  -g|--gallery) GALLERY=1;shift;;
  *) show_help; echo "Unknown parameter passed: $1"; exit 1; shift; shift;;
esac; done

sleep 0.2

if [ "$GALLERY" = 1 ]; then
  xclip -selection clipboard -t image/png -i "$(ls -t ~/Screenshots/*.png /tmp/20*.png | sxiv -ft -i -o)"

elif [ "$OCR" = 1 ]; then
  ~/bin/ocr-region-to-clipboard.bash && notify-send "Copied to clipboard:" "$(xsel -bo)"

elif [ "$TYPE" = Region ] && command -v sx4 > /dev/null 2>&1 ; then
  geometry="$(sx4)"
  [ "$geometry" ] || exit
  FILENAME="$(date '+%F %H.%M.%S') $(echo "$geometry" | cut -d, -f3- | tr , x) $TYPE.png"
  if [ "$CLIPBOARD" = 1 ]; then
    FILENAME=/tmp/"$FILENAME"
    sxot -g $geometry | optipng-pipe | tee "$FILENAME" | copyq write image/png -
  else
    FILENAME=~/Screenshots/"$FILENAME"
    sxot -g $geometry | optipng-pipe > "$FILENAME"
  fi
  notify-send "$FILENAME"

else
  FILENAME='%Y-%m-%d %H.%M.%S $wx$h '$TYPE.png
  NOTIFICATION='echo "$f" && notify-send -u low "$f"'
  if [ "$CLIPBOARD" = 1 ]; then
    scrot $PARAM /tmp/"$FILENAME" -e "copyq write image/png - < '\$f' && $NOTIFICATION"
  else
    scrot $PARAM ~/Screenshots/"$FILENAME" -e "$NOTIFICATION"
  fi
fi
