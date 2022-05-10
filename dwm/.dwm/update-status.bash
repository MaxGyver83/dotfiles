#!/bin/bash
notmuch help &> /dev/null && mailinfo="✉$(notmuch search tag:unread | wc -l), " || mailinfo=""

[ "$USER" = schimax ] && network=$(~/bin/check_network.bash)", " || network=""

monitor_xpos=$(xdotool getactivewindow getwindowgeometry | grep Position | grep -o '[0-9]*,' | sed 's/,//')
active_monitor=$(xrandr | grep -w connected | grep "+$monitor_xpos+" | head -n 1 | cut -d " " -f1)
brightness_percent=$(echo $(xrandr --verbose | grep "^$active_monitor" -A 5 | awk '/Brightness/ { print $2; exit }')'*100' | bc | sed 's/\.00\?//')
[ $brightness_percent = 100 ] && brightness="" || brightness=☀"${brightness_percent}%, "

battery=""
if test -f /sys/class/power_supply/BAT0/capacity ; then
  battery_charge_level=$(cat /sys/class/power_supply/BAT0/capacity)
  [ $battery_charge_level = 100 ] || battery=⎓"${battery_charge_level}%, "
fi

dat=$(date "+%a %F %R")


xsetroot -name "${mailinfo}${network}${brightness}${battery}${dat}"
