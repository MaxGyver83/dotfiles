#!/bin/bash

# dwm statusbar - show current date and time
while true; do
    notmuch help &> /dev/null && mailinfo="✉$(notmuch search tag:unread | wc -l), " || mailinfo=""
    brightness=☀$(echo $(xrandr --verbose | awk '/Brightness/ { print $2; exit }')'*100' | bc | sed 's/\.00\?//')"%, "
    battery=⎓$(cat /sys/class/power_supply/BAT0/capacity)"%, "
    dat=$(date "+%a %F %R")
    xsetroot -name "${mailinfo}${brightness}${battery}${dat}"
    sleep 20
done &

# start dwm
while true; do
    # Log stderror to a file
    dwm &> ~/.dwm.log
done
