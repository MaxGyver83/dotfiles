#!/bin/bash

# dwm statusbar - show current date and time
while true; do
    ~/.dwm/update-status.bash

    seconds=$(date +%-S)
    seconds_to_full_minute=$(( 60 - $seconds ))
    # echo "$dat: Sleeping for $seconds_to_full_minute seconds." >> ~/.dwm.sleeping.log
    sleep $seconds_to_full_minute
done &

# fix for bug with floating windows and Java programs
export _JAVA_AWT_WM_NONREPARENTING=1
#export AWT_TOOLKIT=MToolkit

mkdir -p ~/log

# start dwm
while true; do
    # Log stderror to a file
    dwm > ~/log/dwm.log 2>&1
done
