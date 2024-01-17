#!/bin/sh
connected_devices="$(xrandr | awk '/ conn/{print $1}')"

case "$connected_devices" in
*eDP1*) laptop=eDP1;;
*eDP-1*) laptop=eDP-1;;
*) echo "Couldn't identify laptop screen!"; exit 1;;
esac

external_devices="$(echo "$connected_devices" | grep -v $laptop)"

command="xrandr --output $laptop --primary --mode 1920x1080 --pos 0x0 --rotate normal"
for device in $external_devices ; do
    command="$command --output $device --off"
done

echo "$command"
$command
