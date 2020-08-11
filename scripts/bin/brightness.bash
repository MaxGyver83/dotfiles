#!/bin/bash

BRIGHT=$(stdbuf -o0 xrandr --verbose | awk '/Brightness/ { print $2; exit }')

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
else
    echo $BRIGHT
    exit 0
fi

xrandr --output eDP-1 --brightness "$NEWBRIGHT"
notify-send -t 500 $(echo "$NEWBRIGHT * 100" | bc | sed 's/\.00//')"%"
