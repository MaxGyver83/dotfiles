#!/bin/bash
grep --color -B 8 120013 /proc/bus/input/devices | grep --color -E '^N|^H|^$' | grep --color -P '"(.*?)"|input\d+|event\d+|^$'

events=$(grep -B 8 120013 /proc/bus/input/devices | grep -E '^N|^H|^$' | grep -P '"(.*?)"|input\d+|event\d+|^$' | grep -oP 'event\d+')

while IFS= read -r event ; do
    echo -e "\n\033[1m/dev/input/$event\033[0m"
    find -L /dev/input -samefile "/dev/input/$event" | grep -v "/dev/input/$event"
done <<< "$events"
