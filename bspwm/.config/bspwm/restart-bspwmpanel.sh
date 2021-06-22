#!/bin/sh

# number of used monitors
num_mon_active=$(xrandr | grep -w connected | grep -E ' [0-9]{4}x[0-9]{4}' | wc -l)
# number of connected monitors
# num_mon_conn=$(bspc query -M | wc -l)

# xrandr | grep -w connected | grep -E ' [0-9]{4}x[0-9]{4}'
# bspc query -M --names
# [ $num_mon_conn -ne $num_mon_active ] && sleep 1

if [ $num_mon_active = 1 ]; then
  bspc monitor primary -d term web other
else
  bspc monitor primary -d 1 2
  bspc monitor next    -d 3 4
fi

pkill -x panel_bar > /dev/null
cd ~/.config/bspwm/panel && ./panel &

PANEL_WM_NAME=bspwm_panel
wid=$(xdo id -m -a "$PANEL_WM_NAME")
xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" "$wid"

pkill -x trayer > /dev/null
trayer --edge top --align right --margin 220 --widthtype request --height 28 --tint 0x292b2e --transparent true --expand true --SetDockType true --alpha 0 &
