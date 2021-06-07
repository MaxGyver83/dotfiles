#!/bin/bash

# dwm statusbar - show current date and time
while true; do
    ~/.dwm/update-status.bash

    seconds=$(date +%-S)
    seconds_to_full_minute=$(( 60 - $seconds ))
    # echo "$dat: Sleeping for $seconds_to_full_minute seconds." >> ~/.dwm.sleeping.log
    sleep $seconds_to_full_minute
done &

# start dwm
while true; do
    # Log stderror to a file
    dwm &> ~/.dwm.log
done
