#!/bin/bash

# dwm statusbar - show current date and time
while true; do
    notmuch help &> /dev/null && mailinfo="✉$(notmuch search tag:unread | wc -l), " || mailinfo=""
    brightness_percent=$(echo $(xrandr --verbose | awk '/Brightness/ { print $2; exit }')'*100' | bc | sed 's/\.00\?//')
    [ $brightness_percent = 100 ] && brightness="" || brightness=☀"${brightness_percent}%, "
    battery_charge_level=$(cat /sys/class/power_supply/BAT0/capacity)
    [ $battery_charge_level = 100 ] && battery="" || battery=⎓"${battery_charge_level}%, "
    dat=$(date "+%a %F %R")
    xsetroot -name "${mailinfo}${brightness}${battery}${dat}"
    seconds=$(date +%S)
    seconds_to_full_minute=$(( 60 - $seconds ))
    # echo "$(date): Sleeping for $seconds_to_full_minute seconds." >> ~/.dwm.sleeping.log
    sleep $seconds_to_full_minute
done &

# start dwm
while true; do
    # Log stderror to a file
    dwm &> ~/.dwm.log
done
