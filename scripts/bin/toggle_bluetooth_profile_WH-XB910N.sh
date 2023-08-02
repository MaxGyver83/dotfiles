#!/bin/sh

if [ "$1" = --status ]
then
    print_status=1
fi

active_profile="$(pacmd list-cards | sed -n '/WH-XB910N/,${p;/active profile:/q}' | tail -n 1 | grep -oP '<(.*)>')"
if [ -z "$active_profile" ]
then
    [ "$print_status" = 1 ] || echo "WH-XB910N not found!"
    exit 0
fi

if [ "$active_profile" = '<headset_head_unit>' ]
then
    if [ "$print_status" = 1 ]
    then
        echo HFP
        exit 0
    fi
    new_profile=a2dp_sink
    echo "Setting profile A2DP"
else
    if [ "$print_status" = 1 ]
    then
        echo A2DP
        exit 0
    fi
    new_profile=headset_head_unit
    echo "Setting profile HFP/HSP"
fi
pacmd set-card-profile bluez_card.90_7A_58_77_64_03 $new_profile
~/.config/dwm/update-status.bash
