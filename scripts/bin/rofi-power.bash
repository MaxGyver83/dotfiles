#!/usr/bin/env bash

# rofi-power
# Use rofi to call systemctl for shutdown, reboot, etc

# 2016 Oliver Kraitschy - http://okraits.de

wmctrl -m | grep -q bspwm && WM=bspwm || WM=dwm

if [ $WM = bspwm ]; then
  OPTIONS="Lock screen\nPower-off system\nReboot system\nQuit bspwm (logout)\nRestart bspwm"
else
  OPTIONS="Lock screen\nPower-off system\nReboot system\nKill dwm (logout)\nRestart dwm"
fi

# source configuration or use default values
if [ -f $HOME/.config/rofi-power/config ]; then
  source $HOME/.config/rofi-power/config
else
  LAUNCHER="rofi -width 30 -dmenu -i -p rofi-power"
  USE_LOCKER="false"
  LOCKER="i3lock"
fi

# Show exit wm option if exit command is provided as an argument
if [ ${#1} -gt 0 ]; then
  OPTIONS="Exit window manager\n$OPTIONS"
fi

option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $1}' | tr -d '\r\n'`
if [ ${#option} -gt 0 ]
then
    case $option in
      Exit)
        eval $1
        ;;
      Reboot)
        systemctl reboot
        ;;
      Power-off)
        systemctl poweroff
        ;;
      Lock)
        png="$(xdg-user-dir PICTURES)/Leo4.png" && test -f "$png" && i3lock -e -f -i "$png" -t || i3lock -e -f -c 333333
        ;;
      Restart)
        [ $WM = bspwm ] && bspc wm -r || pkill -f '^dwm'
        ;;
      Kill|Quit)
        [ $WM = bspwm ] && bspc quit || pkill dwm
        ;;
      # Suspend)
      #   $($USE_LOCKER) && "$LOCKER"; systemctl suspend
      #   ;;
      # Hibernate)
      #   $($USE_LOCKER) && "$LOCKER"; systemctl hibernate
      #   ;;
      *)
        ;;
    esac
fi
