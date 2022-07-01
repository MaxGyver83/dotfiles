#!/bin/sh

BRIGHT=$(stdbuf -o0 xrandr --verbose | awk '/Brightness/ { print $2; exit }')

STEP=0.1

if [ "$1" = '+' ]; then
    /usr/bin/pactl set-sink-volume "@DEFAULT_SINK@" "+5%"
    notify-send -t 500 $(amixer sget Master | grep 'Mono:' | awk '{print $4,$6}')

elif [ "$1" = '-' ]; then
    /usr/bin/pactl set-sink-volume "@DEFAULT_SINK@" "-5%"
    notify-send -t 500 $(amixer sget Master | grep 'Mono:' | awk '{print $4,$6}')
else
    # toggle mute
    /usr/bin/pactl set-sink-mute "@DEFAULT_SINK@" toggle
    notify-send -t 500 $(amixer sget Master | grep 'Mono:' | awk '{print $4,$6}')
fi

