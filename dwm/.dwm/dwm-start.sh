#!/bin/bash

# dwm statusbar - show current date and time
while true; do
    notmuch -v &> /dev/null && mailinfo="$(notmuch search tag:unread | wc -l) ✉, " || mailinfo=""
    xsetroot -name "${mailinfo}$(cat /sys/class/power_supply/BAT0/capacity)%, $(date "+%a %F %R")"
    sleep 20
done &

# start dwm
while true; do
    # Log stderror to a file
    dwm &> ~/.dwm.log
done
