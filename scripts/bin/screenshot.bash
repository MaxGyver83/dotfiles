#!/usr/bin/env bash

show_help() {
  echo "Arguments:
  -c|--clipboard   Save screenshot in /tmp and copy into clipboard
  -s|--screen      Take screenshot of all screens (with sxot: current screen!?)
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

elif command -v sxot > /dev/null 2>&1 ; then
  pgrep picom > /dev/null && PICOM=1 && pkill picom
  DATE="$(date '+%F %H.%M.%S')"
  case "$TYPE" in
  Region)
    geometry="$(sx4)"
    [ "$geometry" ] || { [ "$PICOM" ] && picom; exit; }
    WxH="$(echo "$geometry" | cut -d, -f3- | tr , x) "
    GEOMETRY_ARGS="-g $geometry"
    ;;
  Window)
    geometry="$(xdotool getwindowfocus getwindowgeometry | awk '/Position|Geometry/ {print $2}' | tr x , | paste -sd ,)"
    [ "$geometry" ] || { [ "$PICOM" ] && picom; exit; }
    WxH="$(echo "$geometry" | cut -d, -f3- | tr , x) "
    GEOMETRY_ARGS="-g $geometry"
    ;;
  Screen)
    # TODO: add "wxh"?
    WxH=''
    GEOMETRY_ARGS=''
    ;;
  *) exit 1 ;;
  esac

  [ "$CLIPBOARD" = 1 ] && DIR=/tmp || DIR=~/Screenshots
  FILENAME="$DIR/$DATE ${WxH}$TYPE.png"

  sxot $GEOMETRY_ARGS | ffmpeg -hide_banner -loglevel error -i - "$FILENAME"
  [ "$CLIPBOARD" = 1 ] && copyq write image/png - < "$FILENAME"
  notify-send -t 1000 -u low "$FILENAME"
  [ "$PICOM" ] && picom

else
  FILENAME='%Y-%m-%d %H.%M.%S $wx$h '$TYPE.png
  NOTIFICATION='echo "$f" && notify-send -u low "$f"'
  if [ "$CLIPBOARD" = 1 ]; then
    scrot $PARAM /tmp/"$FILENAME" -e "copyq write image/png - < '\$f' && $NOTIFICATION"
  else
    scrot $PARAM ~/Screenshots/"$FILENAME" -e "$NOTIFICATION"
  fi
fi
