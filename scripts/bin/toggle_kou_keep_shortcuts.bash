#!/bin/bash
echo -e "\nRunning toggle_kou_keep_shortcuts.bash"

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }
# explanation: https://stackoverflow.com/questions/1378274/in-a-bash-script-how-can-i-exit-the-entire-script-if-a-certain-condition-occurs

use_setxkbmap=true

(! ps -e | grep kou_maxs) # ! inverts the result
kou_service_running=$?    # = 1 if running

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

echo "kou_service_running = $kou_service_running"
echo "kou_layout_activated = $kou_layout_activated"
echo "xcape_running = $xcape_running"
echo "usb_keyboard_plugged_in = $usb_keyboard_plugged_in"

echo "pgrep -a ^kou:"
pgrep -a ^kou
echo ""

function start_kou_shortcut_remapping {
    echo "Starting kou..."
    if [ "$HOSTNAME" = "max-B9440UA" ]; then
        #tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-path/platform-i8042-serio-0-event-kbd keyb'
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-path/platform-i8042-serio-0-event-kbd keyb >> $HOME/kou_log_new.txt'
        #tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-path/pci-0000:00:14.0-usb-0:2.3:1.0-event-kbd keyb'  # Koolertron 1
        #tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-path/pci-0000:00:14.0-usb-0:2.2:1.0-event-kbd keyb'  # Koolertron 2
        #tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/event11 keyb'  # Koolertron 1
        #tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/event13 keyb'  # Koolertron 2
        #tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-path/pci-0000:00:14.0-usb-0:2.4:1.0-event-kbd /dev/input/by-path/pci-0000:00:14.0-usb-0:2.2:1.0-event-kbd keyb'  # Koolertron 1+2
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-kbd Logi >> $HOME/kou_log_new.txt'
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd Telink >> $HOME/kou_log_new.txt'
        #tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-Chicony_USB_Keyboard-event-kbd keyb'  # perixx
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-You_idobo_0-event-kbd idobo'  # idobo
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-Apple_Inc._Apple_Keyboard-event-kbd keyb'  # idobo
        # tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-LingYao_ShangHai_Thumb_Keyboard_081820131130-event-kbd keyb'  # Koolertron
    else
        # Laptop keyboard
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-path/platform-i8042-serio-0-event-kbd keyb >> $HOME/kou_log_new.txt'
        # Dell keyboard
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-413c_Dell_KB216_Wired_Keyboard-event-kbd keyb'
        # Cherry keyboard
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-046a_0023-event-kbd HID'
        # Jelly Comb KS37
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd Telink >> $HOME/kou_log_new.txt'
        # Sunnyvale: Logitech K400
        tmux new-session -d 'sudo /usr/local/sbin/kou_maxs /dev/input/event20 K400'
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

    if ! (xkbcomp $DISPLAY /tmp/tmp.xkb && grep -iq 'name\[group.*\]=".*KOU.*"' /tmp/tmp.xkb); then
        echo "set KOU layout"
        sleep 1
        echo DISPLAY=$DISPLAY
        DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
        echo DIR=$DIR

        #echo 'test -f "$DIR/kou.xkb" = '(test -f "$DIR/kou.xkb")
       test -f "$DIR/kou.xkb" && xkbcomp "$DIR/kou.xkb" $DISPLAY || { zenity --error --text="Couldn't load KOU layout!"; die "'$DIR/kou.xkb' not found!"; }
        # test -f "/home/max/workspace/xkbcomp-test/kou.xkb" && xkbcomp "/home/max/workspace/xkbcomp-test/kou.xkb" $DISPLAY || { zenity --error --text="Couldn't load KOU layout!"; die "'$DIR/kou.xkb' not found!"; }
        xkbcomp $DISPLAY /tmp/tmp_after.xkb
    fi
}

function setup_kou {
    # start kou service, set keyboard layout, (start xcape)

    (! ps -e | grep kou_maxs) # ! inverts the result
    kou_service_running=$?    # = 1 if running
    echo "kou_service_running = $kou_service_running"

    if ((! $kou_service_running )); then
        start_kou_shortcut_remapping
    fi

    # set KOU layout
    if [ "$use_setxkbmap" = true ]; then
        set_kou_layout
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


if (( $usb_keyboard_plugged_in )) ; then
    # if kou_service is running, restart it, and set layout to kou
    # otherwise, layout was QWERTZ, and I really want to switch to kou: activate kou
    if (( $kou_service_running )); then
        echo "sudo pkill ^kou_maxs"
        # sudo pkill -x kou_maxs
        # kill process and wait for the process be killed
        while sudo pkill ^kou_maxs; do sleep 0.1; done;
    fi
    setup_kou

elif (( $kou_layout_activated  )) ; then
    if (( $kou_service_running )); then
        echo "sudo pkill ^kou_maxs"
        sudo pkill ^kou_maxs
    fi
    if (( $xcape_running )) ; then
        echo "sudo pkill xcape"
        sudo pkill xcape
    fi
    # set QWERTZ layout
    echo "set QWERTZ layout"
    setxkbmap de -option
    notify-send -i /usr/share/icons/gnome/48x48/devices/input-keyboard.png -u low --hint int:transient:1 'Switched to QWERTZ layout'
    # deactivate scroll lock LED
    # xset -led named "Scroll Lock"

else
    setup_kou
fi
#sleep 1
#echo 'ps -e | grep kou'
#ps -e | grep kou
#setxkbmap -query | grep -v "rules:" | grep -v "model:"
