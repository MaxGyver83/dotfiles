#!/bin/bash

# dwm statusbar - show current date and time
while true; do
    xsetroot -name "$(notmuch search tag:unread | wc -l) ✉, $(cat /sys/class/power_supply/BAT0/capacity)%, $(date "+%a %F %R")"
    sleep 10
done &

# start dwm
while true; do
    # Log stderror to a file
    dwm &> ~/.dwm.log
done
