#!/bin/bash
notmuch help &> /dev/null && mailinfo="✉$(notmuch search tag:unread | wc -l), " || mailinfo=""

monitor_xpos=$(xdotool getactivewindow getwindowgeometry | grep Position | grep -o '[0-9]*,' | sed 's/,//')
active_monitor=$(xrandr | grep -w connected | grep "+$monitor_xpos+" | head -n 1 | cut -d " " -f1)
brightness=☀$(echo $(xrandr --verbose | grep "^$active_monitor" -A 5 | awk '/Brightness/ { print $2; exit }')'*100' | bc | sed 's/\.00\?//')"%, "

battery=⎓$(cat /sys/class/power_supply/BAT0/capacity)"%, "

dat=$(date "+%a %F %R")

xsetroot -name "${mailinfo}${brightness}${battery}${dat}"
