#!/bin/bash
# notmuch help &> /dev/null && mailinfo="✉$(notmuch search tag:unread | wc -l), " || mailinfo=""

exists() { command -v "$1" > /dev/null 2>&1 ; }
round() { LC_ALL=C printf '%.0f' "$1" ; }
office_lan() { ip -br -4 a show dev enx0c379667313c 2> /dev/null | awk '{print $3}' | grep -q '^10\.' ; }
office_wifi() { ip -br -4 a show dev wlp0s20f3 2> /dev/null | grep -Eq 'UP\ +10\.' ; }
vpn() { ip -br -4 a show dev tun0 2> /dev/null | awk '{print $3}' | grep -q '^10\.' ; }
kerb() { klist -s ; }


if test -f ~/bin/toggle_bluetooth_profile_WH-XB910N.sh ; then
  headset_profile="$(~/bin/toggle_bluetooth_profile_WH-XB910N.sh --status)"
  [ "$headset_profile" ] && headset_profile="${headset_profile}  "
fi

if [[ "$USER" =~ sc* ]]; then
  office_lan || office_wifi || { vpn || network="No VPN "; }
  kerb || network+="No Kerb "
fi

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
