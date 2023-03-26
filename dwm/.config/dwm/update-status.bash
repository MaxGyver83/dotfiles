#!/bin/bash
# notmuch help &> /dev/null && mailinfo="✉$(notmuch search tag:unread | wc -l), " || mailinfo=""

exists() { command -v "$1" > /dev/null 2>&1 ; }
round() { LC_ALL=C printf '%.0f' "$1"; }

if test -f ~/bin/toggle_bluetooth_profile_WH-XB910N.sh ; then
  headset_profile="$(~/bin/toggle_bluetooth_profile_WH-XB910N.sh --status)"
  [ "$headset_profile" ] && headset_profile="${headset_profile}  "
fi

[ "$USER" = schimax ] && network=$(~/bin/check_network.bash)"  " || network=""

monitor_xpos=$(xdotool getactivewindow getwindowgeometry | grep Position | grep -o '[0-9]*,' | sed 's/,//')
active_monitor=$(xrandr | grep -w connected | grep "+$monitor_xpos+" | head -n 1 | cut -d " " -f1)
if [ "$(hostname)" = 'max-laptop' ] && [ "$active_monitor" = 'eDP-1' ] && exists light ; then
  brightness_percent="$(round "$(light -G)")"
else
  brightness_percent=$(xrandr --verbose | grep "^$active_monitor" -A 5 | awk '/Brightness/ { printf "%.0f\n", $2 * 100; exit }')
fi
[ $brightness_percent = 100 ] && brightness="" || brightness=☀"${brightness_percent}%  "

battery=""
if test -f /sys/class/power_supply/BAT0/status ; then
  battery_status=$(cat /sys/class/power_supply/BAT0/status)
  [ "$battery_status" = Charging ] && battery="⎓↑"
fi
if test -f /sys/class/power_supply/BAT0/capacity ; then
  battery_charge_level=$(cat /sys/class/power_supply/BAT0/capacity)
  [ $battery_charge_level = 100 ] || battery="${battery:-⎓}${battery_charge_level}%"
fi
[ "$battery" ] && battery="$battery  "

dat=$(date "+%a %F %R")


xsetroot -name "${headset_profile}${mailinfo}${network}${brightness}${battery}${dat}"
