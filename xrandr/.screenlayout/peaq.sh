#!/bin/sh
if xrandr | grep -q '^DP3' ; then
  xrandr --output eDP1-1 --off \
         --output eDP1 --off \
         --output DP1-1-3 --off \
         --output DP1-1-2 --off \
         --output DP1-1-1 --off \
         --output DP1-3 --off \
         --output DP1-2 --off \
         --output DP1-1 --off \
         --output DP3 --primary --mode 2560x1440 --pos 0x0 --rotate normal

elif xrandr | grep -w connected | grep -q '^DP-1-1 ' ; then
  xrandr --output HDMI-1-2 --off \
         --output eDP-1-1 --off \
         --output HDMI-1-1 --off \
         --output DP-1-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
         --output DP-1-2 --off

elif xrandr | grep -w connected | grep -q '^HDMI-1-1 ' ; then
  xrandr --output HDMI-1-2 --off \
         --output eDP-1-1 --off \
         --output HDMI-1-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
         --output DP-1-1 --off \
         --output DP-1-2 --off

elif xrandr | grep -w connected | grep -q '^DP-1-1-1 ' ; then
  xrandr --output eDP-1-1 --off \
         --output DP-1-1-3 --off \
         --output DP-1-1-2 --off \
         --output DP-1-1-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
         --output DP-1-3 --off \
         --output DP-1-2 --off \
         --output DP-1-1 --off

elif xrandr | grep -w connected | grep -q '^DP-3 ' ; then
  xrandr --output eDP-1-1 --off \
         --output eDP-1 --off \
         --output DP-1-1-3 --off \
         --output DP-1-1-2 --off \
         --output DP-1-1-1 --off \
         --output DP-1-3 --off \
         --output DP-1-2 --off \
         --output DP-1-1 --off \
         --output DP-3 --primary --mode 2560x1440 --pos 0x0 --rotate normal

else
  # laptop only
  laptop=$(xrandr | grep eDP | cut -d' ' -f1)
  xrandr --output $laptop --primary --mode 1920x1080 --pos 0x0 --rotate normal \
         --output HDMI-1-2 --off \
         --output HDMI-1-1 --off \
         --output DP-1-1-3 --off \
         --output DP-1-1-2 --off \
         --output DP-1-1-1 --off \
         --output DP-1-2 --off \
         --output DP-1-1 --off
fi
