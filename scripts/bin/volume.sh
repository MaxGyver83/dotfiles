#!/bin/sh

notify() {
    status=$(amixer sget Master | grep 'Mono:' | awk '{print $4,$6}' | tr -d '[]' | sd ' on' '' | sd 'off' '(muted)')
    notify-send -t 500 "$status"
}

if [ "$1" = '+' ]; then
    /usr/bin/pactl set-sink-volume "@DEFAULT_SINK@" "+5%"
elif [ "$1" = '-' ]; then
    /usr/bin/pactl set-sink-volume "@DEFAULT_SINK@" "-5%"
else
    # toggle mute
    /usr/bin/pactl set-sink-mute "@DEFAULT_SINK@" toggle
fi

notify
