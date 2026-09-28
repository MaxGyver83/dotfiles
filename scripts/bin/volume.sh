#!/bin/sh

# Without a real output device (headphones via jack or Bluetooth), PipeWire
# falls back to the dummy sink "auto_null" and the script controls nothing.
no_device() {
    case "$(pactl get-default-sink)" in
        ''|auto_null|sink_dummy) return 0 ;;
        *) return 1 ;;
    esac
}

notify() {
    if no_device; then
        notify-send -t 3000 'No headphones connected' 'Please plug them in or connect over Bluetooth.'
        return
    fi

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
