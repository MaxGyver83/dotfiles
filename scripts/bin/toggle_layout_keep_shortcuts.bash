#!/bin/bash
# Toggle KOU/QWERTZ keyboard layout.
# If a layout is given as an argument, activate this layout. (qwertz/kou/vou)
echo -e "\nRunning toggle_layout_keep_shortcuts.bash"

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }
# explanation: https://stackoverflow.com/questions/1378274/in-a-bash-script-how-can-i-exit-the-entire-script-if-a-certain-condition-occurs

use_setxkbmap=false
use_tmux=false

if [ "$use_tmux" = true ]; then
    cmd_part1='tmux new -s '
    cmd_part2=' -d '
else
    cmd_part1='screen -S '
    cmd_part2=' -dm bash -c '
fi

(! ps -e | grep kou_maxs) # ! inverts the result
kou_service_running=$?    # = 1 if running

(! ps -e | grep vou_maxs) # ! inverts the result
vou_service_running=$?    # = 1 if running

(! ps -e | grep xcape)    # ! inverts the result
xcape_running=$?          # = 1 if running

if [ "$use_setxkbmap" = true ]; then
    (! setxkbmap -query | grep -q "variant:\s\+kou")
else
    ! ( xkbcomp $DISPLAY /tmp/tmp.xkb && grep -iq 'name\[group.*\]=".*KOU.*"' /tmp/tmp.xkb )
fi
kou_layout_activated=$?   # = 1 if activated

(! setxkbmap -query | grep -q "variant:\s\+,")
usb_keyboard_plugged_in=$?   # = 1 if usb keyboard has been plugged in

desired_layout="$1"

echo -e "\nCurrent status:"
echo "vou_service_running = $vou_service_running"
echo "kou_service_running = $kou_service_running"
echo "kou_layout_activated = $kou_layout_activated"
echo "xcape_running = $xcape_running"
echo "usb_keyboard_plugged_in = $usb_keyboard_plugged_in"
if [ -n "$desired_layout" ]; then
    echo "desired layout = $desired_layout"
fi

echo "pgrep -a ^kou:"
pgrep -a ^kou
echo ""

function start_layout_shortcut_remapping {
    if [ -n "$desired_layout" ]; then
        layout="$desired_layout"
    else
        layout="kou"
    fi

    echo "Starting ${layout}..."
    log_file="$HOME/${layout}_log_new_level3.txt"
    exec="/usr/local/sbin/${layout}_maxs"
    if [ "$HOSTNAME" = "max-B9440UA" ]; then
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-path/platform-i8042-serio-0-event-kbd keyb >> $log_file"
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd Logi >> $log_file"
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd Telink >> $log_file"
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-id/usb-You_idobo_0-event-kbd idobo"  # idobo
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-id/usb-Apple_Inc._Apple_Keyboard-event-kbd keyb"  # Apple
    else
        # Laptop keyboard
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-path/platform-i8042-serio-0-event-kbd keyb >> $log_file"
        # Dell keyboard
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-id/usb-413c_Dell_KB216_Wired_Keyboard-event-kbd keyb"
        # Cherry keyboard
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-id/usb-046a_0023-event-kbd HID"
        # Jelly Comb KS37
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd Telink >> $log_file"
        # Sunnyvale: Logitech K400
        ${cmd_part1}${layout}_$(date +"%H%M%S_%3N")${cmd_part2}"sudo $exec /dev/input/event20 K400"
    fi
}


function set_kou_layout {
    setxkbmap -query
    while ! (setxkbmap -query | grep -q "variant:\s\+kou") ; do
        echo "set KOU layout"
        sleep 1
        # works after second call of this script !?
        setxkbmap de kou -option ctrl:swap_lalt_lctl_lwin || { zenity --error --text="Couldn't load layout 'de kou'!"; die "layout 'de kou' not found!"; }
    done
}

function set_vou_layout {
    setxkbmap -query
    while ! (setxkbmap -query | grep -q "variant:\s\+vou") ; do
        echo "set VOU layout"
        sleep 1
        # works after second call of this script !?
        setxkbmap de vou -option ctrl:swap_lalt_lctl_lwin || { zenity --error --text="Couldn't load layout 'de vou'!"; die "layout 'de vou' not found!"; }
    done
}

function set_kou_layout_without_sudo {
# Problem: After activating KOU with this function, setxkbmap and xkbcomp see two layouts defined (as if an external keyboard was connected)

# ~/workspace/xkbcomp-test > setxkbmap -query
# rules:      evdev
# model:      pc105
# layout:     de,de
# variant:    ,

# ~/workspace/xkbcomp-test > xkbcomp $DISPLAY /tmp/tmp.xkb && grep -i 'name\[group.*\]=".*"' /tmp/tmp.xkb
#     name[group1]="German (KOU, Max S.)";
#     name[group2]="German";

    if ! (xkbcomp $DISPLAY /tmp/tmp.xkb && grep -iq 'name\[group.*\]=".*[KV]OU.*"' /tmp/tmp.xkb); then
        if [ -n "$desired_layout" ]; then
            layout="$desired_layout"
        else
            layout="kou"
        fi

        echo "set ${layout^^} layout"
        sleep 1
        echo DISPLAY=$DISPLAY
        DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
        echo DIR=$DIR

        #echo 'test -f "$DIR/kou.xkb" = '(test -f "$DIR/kou.xkb")
       test -f "$DIR/$layout.xkb" && xkbcomp "$DIR/$layout.xkb" $DISPLAY || { zenity --error --text="Couldn't load ${layout^^} layout!"; die "'$DIR/$layout.xkb' not found!"; }
        # test -f "/home/max/workspace/xkbcomp-test/kou.xkb" && xkbcomp "/home/max/workspace/xkbcomp-test/kou.xkb" $DISPLAY || { zenity --error --text="Couldn't load KOU layout!"; die "'$DIR/kou.xkb' not found!"; }
        xkbcomp $DISPLAY /tmp/tmp_after.xkb
    fi
}

function setup_kou {
    # start kou/vou service, set keyboard layout, (start xcape)

    (! ps -e | grep kou_maxs) # ! inverts the result
    kou_service_running=$?    # = 1 if running
    echo "kou_service_running = $kou_service_running"

    (! ps -e | grep vou_maxs) # ! inverts the result
    vou_service_running=$?    # = 1 if running
    echo "vou_service_running = $vou_service_running"

    if ((! $kou_service_running )); then
        if ((! $vou_service_running )); then
            start_layout_shortcut_remapping
        fi
    fi

    # set KOU layout
    if [ "$use_setxkbmap" = true ]; then
        [ "$desired_layout" = "vou"] && set_vou_layout || set_kou_layout
    else
        set_kou_layout_without_sudo
    fi

    # linker Mod3 = Escape, wenn allein gedrückt
    # xcape -e "#66=Escape" -t 200 || zenity --info --text="xcape error! Is it installed?"

    notify-send -i /usr/share/icons/gnome/48x48/devices/input-keyboard.png -u low --hint int:transient:1 'Switched to KOU layout'
    # after first call: layout: de,de ; variant: ,
    # activate scroll lock LED
    # xset led named "Scroll Lock"
}

function stop_kou_vou_maxs_xcape {
    if (( $vou_service_running )); then
        echo "sudo pkill ^vou_maxs"
        # sudo pkill -x vou_maxs
        # kill process and wait for the process be killed
        while sudo pkill ^vou_maxs; do sleep 0.1; done;
    fi
    if (( $kou_service_running )); then
        echo "sudo pkill ^kou_maxs"
        # sudo pkill -x kou_maxs
        # kill process and wait for the process be killed
        while sudo pkill ^kou_maxs; do sleep 0.1; done;
    fi
    if (( $xcape_running )) ; then
        echo "sudo pkill xcape"
        sudo pkill xcape
    fi
}


if [ -n "$desired_layout" ]; then
    if [ "$desired_layout" = "qwertz" ]; then
        echo "Stop KOU."
        stop_kou_vou_maxs_xcape
        echo "set QWERTZ layout"
        setxkbmap de -option
        notify-send -i /usr/share/icons/gnome/48x48/devices/input-keyboard.png -u low --hint int:transient:1 'Switched to QWERTZ layout'
    elif [ "$desired_layout" = "kou" ]; then
        echo "Activate KOU."
        setup_kou
    elif [ "$desired_layout" = "vou" ]; then
        echo "Activate VOU."
        setup_kou
    else
        echo "$1 is not a valid argument!"
        exit 1
    fi
    exit 0
fi

if (( $usb_keyboard_plugged_in )) ; then
    # if kou_service is running, restart it, and set layout to kou
    # otherwise, layout was QWERTZ, and I really want to switch to kou: activate kou
    echo "KOU active or maybe a USB keyboard has been connected. Stop KOU."
    stop_kou_vou_maxs_xcape
    # setup_kou  # stop KOU for now
    echo "set QWERTZ layout"
    setxkbmap de -option
    notify-send -i /usr/share/icons/gnome/48x48/devices/input-keyboard.png -u low --hint int:transient:1 'Switched to QWERTZ layout'

elif (( $kou_layout_activated  )) ; then
    echo "Stop KOU."
    stop_kou_vou_maxs_xcape
    # set QWERTZ layout
    echo "set QWERTZ layout"
    setxkbmap de -option
    notify-send -i /usr/share/icons/gnome/48x48/devices/input-keyboard.png -u low --hint int:transient:1 'Switched to QWERTZ layout'
    # deactivate scroll lock LED
    # xset -led named "Scroll Lock"

else
    echo "Activate KOU."
    setup_kou
fi
#sleep 1
#echo 'ps -e | grep kou'
#ps -e | grep kou
#setxkbmap -query | grep -v "rules:" | grep -v "model:"
