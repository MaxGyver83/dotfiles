#!/bin/sh

activate_one() {
    echo "Activate $1:"
    command="xrandr --output $1 --primary --pos 0x0 --rotate normal"
    if [ "$2" = 4K ]; then
        command="$command --mode 3840x2160 --dpi 120 --scale 1.0x1.0"
    else
        command="$command --auto"
    fi
    # other_devices = connected/configured except the one to be activated
    other_devices="$(printf "%s\n%s" "$connected_devices" "$configured_devices" | sort -u | grep -v -w "$1")"
    for device in $other_devices ; do
        command="$command --output $device --off"
    done
    echo "$command"
    $command
}

activate_both() {
    echo "Activate $*:"
    command="xrandr --output $1 --primary --pos 0x0 --rotate normal --auto"
    if [ "$2" ]; then
        command="$command --output $2 --left-of $1 --primary --auto"
    fi
    # other_devices = connected except the one to be activated
    other_devices="$(echo "$connected_devices" | grep -v -w "$1" | grep -v -w "$2")"
    for device in $other_devices ; do
        command="$command --output $device --off"
    done
    echo "$command"
    $command
}

activate_other() {
    connected_count=$(echo "$connected_devices" | wc -l)
    [ "$connected_count" = 1 ] && exit 0

    active_monitors="$(xrandr --listactivemonitors | awk '{ print $4 }')"
    case "$active_monitors" in
    *$laptop*) activate_one "$first_external_device" ;;
    *)         activate_one "$laptop" ;;
    esac
}

guess_layout() {
    connected_count=$(echo "$connected_devices" | wc -l)
    case "$connected_count" in
    1) activate_one "$laptop" ;;
    *) activate_one "$first_external_device" ;;
    esac
}

connected_devices="$(xrandr | awk '/ conn/{print $1}')"
disconnected_devices="$(xrandr | awk '/disconnected/{print $1}')"
configured_devices="$(xrandr | awk '/connected( primary)? [0-9]/{print $1}')"

case "$connected_devices" in
*eDP1*) laptop=eDP1;;
*eDP-1*) laptop=eDP-1;;
*) laptop=;;
esac

external_devices="$(echo "$connected_devices
$disconnected_devices" | grep -v -w $laptop)"

first_external_device="$(echo "$external_devices" | head -n 1)"

printf "Connected:\n${connected_devices}\n"
printf "\nDisconnected:\n${disconnected_devices}\n"
printf "\nExternal:\n${external_devices}\n\n"

case "$1" in
info) echo "Active:"; xrandr --listactivemonitors; exit 0 ;;
auto) guess_layout ;;
other) activate_other ;;
laptop) [ $laptop ] && activate_one "$laptop" ;;
external) activate_one "$first_external_device" "$2" ;;
all|both|*) activate_both "$laptop" "$first_external_device" ;;
esac

# reload current wallpaper (with updated size/position)
~/.fehbg
