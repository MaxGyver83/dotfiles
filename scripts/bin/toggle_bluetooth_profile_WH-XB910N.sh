#!/bin/sh

card="bluez_card.90_7A_58_77_64_03"

active_profile="$(
    pactl list cards |
    sed -n "/Name: $card/,/^Card #/p" |
    grep 'Active Profile:' |
    sed 's/.*: //'
)"

if [ -z "$active_profile" ]; then
    [ "$1" = --status ] || echo "WH-XB910N not found!"
    exit 0
fi

case "$active_profile" in
a2dp-sink*)
    [ "$1" = --status ] && echo A2DP && exit 0
    new_profile=headset-head-unit
    echo "Setting profile HFP"
    ;;

headset-head-unit*)
    [ "$1" = --status ] && echo HFP && exit 0
    new_profile=a2dp-sink
    echo "Setting profile A2DP (AAC)"
    ;;

*)
    echo "Unknown profile: $active_profile"
    exit 1
    ;;
esac

pactl set-card-profile "$card" "$new_profile"

~/.config/dwm/update-status.bash
