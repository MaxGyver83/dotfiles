#!/bin/sh

activate() {
    echo "Activate $1"
    command="xrandr --output "$1" --primary --pos 0x0 --rotate normal"
    if [ "$2" = 4K ]; then
        command="$command --mode 3840x2160 --dpi 120 --scale 1.0x1.0"
    else
        command="$command --auto"
    fi
    # printf "\nConnected:\n${connected_devices}\n"
    other_devices="$(echo "$connected_devices" | grep -v -w $1)"
    # printf "\nOther:\n${other_devices}\n"
    for device in $other_devices ; do
        command="$command --output $device --off"
    done
    echo $command
    $command
}

connected_devices="$(xrandr | awk '/ conn/{print $1}')"
available_devices="$(xrandr | awk '/connected [0-9]/{print $1}')"

case "$connected_devices" in
*eDP1*) laptop=eDP1;;
*eDP-1*) laptop=eDP-1;;
*) laptop=;;
esac

external_devices="$(echo "$connected_devices
$available_devices" | grep -v -w $laptop)"

# printf "Connected:\n${connected_devices}\n"
# printf "\nAvailable:\n${available_devices}\n"
# printf "\nExternal:\n${external_devices}\n\n"

case "$1" in
laptop) [ $laptop ] && activate "$laptop";;
external) activate "$(echo "$external_devices" | head -n 1)" $2;;
all|both|*) enable="$connected_devices";;
esac