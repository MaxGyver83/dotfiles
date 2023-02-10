#!/bin/sh

activate() {
    echo "Activate $1"
    command="xrandr --output "$1" --primary --pos 0x0 --rotate normal"
    if [ "$2" = 4K ]; then
        command="$command --mode 3840x2160 --dpi 120 --scale 1.0x1.0"
    else
        command="$command --auto"
    fi
    other_devices="$(echo "$connected_devices" | grep -v $1)"
    for device in $other_devices ; do
        command="$command --output $device --off"
    done
    echo $command
    $command
}

connected_devices="$(xrandr | awk '/ conn/{print $1}')"

case "$connected_devices" in
*eDP1*) laptop=eDP1;;
*eDP-1*) laptop=eDP-1;;
*) laptop=;;
esac

external_devices="$(echo "$connected_devices" | grep -v $laptop)"

case "$1" in
laptop) [ $laptop ] && activate "$laptop";;
external) activate "$(echo "$external_devices" | head -n 1)" $2;;
all|both|*) enable="$connected_devices";;
esac
