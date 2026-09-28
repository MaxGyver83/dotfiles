#!/bin/sh

notify() {
    status=$(pactl get-sink-volume "@DEFAULT_SINK@" | grep -oE '[0-9]+%' | head -1)
    [ "$(pactl get-sink-mute "@DEFAULT_SINK@" | sed 's/^Mute: //')" = yes ] && status="$status (muted)"
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
