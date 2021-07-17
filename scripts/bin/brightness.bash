#!/bin/bash

monitor_xpos=$(xdotool getactivewindow getwindowgeometry | grep Position | grep -o '[0-9]*,' | sed 's/,//')
active_monitor=$(xrandr | grep -w connected | grep "+$monitor_xpos+" | head -n 1 | cut -d " " -f1)
# use primary monitor as fallback
[ -z $active_monitor ] && active_monitor=$(xrandr | grep -w 'connected primary' | head -n 1 | cut -d " " -f1)
BRIGHT=$(stdbuf -o0 xrandr --verbose | grep "^$active_monitor" -A 5 | awk '/Brightness/ { print $2; exit }')

STEP=0.1

if [ "$1" = '+' ]; then
    NEWBRIGHT=$(echo "$BRIGHT + $STEP" | bc)
    if [ "$(echo "$NEWBRIGHT > 1.0" | bc)" -eq 1 ]; then
        NEWBRIGHT='1.0'
    fi
elif [ "$1" = '-' ]; then
    NEWBRIGHT=$(echo "$BRIGHT - $STEP" | bc)
    if [ "$(echo "$NEWBRIGHT < 0.1" | bc)" -eq 1 ]; then
        NEWBRIGHT='0.1'
    fi
elif [ "$1" = 'max' ] || [ "$1" = 'full' ]; then
    NEWBRIGHT='1.0'
else
    echo $BRIGHT
    exit 0
fi

# first_monitor=$(xrandr | grep -w connected | head -n 1 | cut -d " " -f1)
# xrandr --output "$first_monitor" --brightness "$NEWBRIGHT"

xrandr --output "$active_monitor" --brightness "$NEWBRIGHT"

notify-send -t 500 $(echo "$NEWBRIGHT * 100" | bc | sed 's/\.00//')"%"
bash ~/.dwm/update-status.bash
