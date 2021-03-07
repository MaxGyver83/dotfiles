#!/usr/bin/env bash

# rofi-screenshot
# Use rofi to take a screenshot

OPTIONS="Screenshot of whole screen\nScreenshot of active window\nScreenshot of selected region\nScreenshot of active window to /tmp and clipboard\nScreenshot of selected region or window to /tmp and clipboard"

LAUNCHER="rofi -width 40 -dmenu -i -p rofi-screenshot"
SLEEP="sleep 0.2"
NOTIFICATION='notify-send -u low "$f"'
FILENAME='%Y-%m-%d %H.%M.%S $wx$h'

option=$(echo -e $OPTIONS | $LAUNCHER | tr -d '\r\n')
echo $option

if [ ${#option} -gt 0 ]
then
    case $option in
      "Screenshot of whole screen")
        $SLEEP ; scrot ~/Screenshots/"$FILENAME Screen.png" -e "$NOTIFICATION"
        ;;
      "Screenshot of active window")
        $SLEEP ; scrot -u ~/Screenshots/"$FILENAME Window.png" -e "$NOTIFICATION"
        ;;
      "Screenshot of selected region")
        $SLEEP ; scrot -s ~/Screenshots/"$FILENAME Region.png" -e "$NOTIFICATION"
        ;;
      "Screenshot of active window to /tmp and clipboard")
        $SLEEP ; scrot -u /tmp/"$FILENAME Window.png" -e "copyq write image/png - < '\$f' && $NOTIFICATION"
        ;;
      "Screenshot of selected region or window to /tmp and clipboard")
        $SLEEP ; scrot -s /tmp/"$FILENAME Region.png" -e "copyq write image/png - < '\$f' && $NOTIFICATION"
        ;;
      *)
        ;;
    esac
fi
