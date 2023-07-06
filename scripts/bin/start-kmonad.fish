#!/usr/bin/fish
argparse 'c/config=' 'k/keyboard=' 't/test' 's/stop' -- $argv

if test -z "$_flag_keyboard"
    echo "\
Usage:  start-kmonad.fish OPTIONS

OPTIONS:
  -k, --keyboard  For example: all, internal, Dell, Jelly, Royal, Keychron, bluetooth [mandatory]
  -c, --config    KMonad config file [default: ~/.config/kmonad/vou-linux-de-rctrl.kbd]
  -s, --stop      Stop KMonad for the given keyboard
  -t, --test      Run ~/repos/kmonad/kmonad (instead of kmonad from PATH)
"
    exit 1
end

if test -n "$_flag_test"
    set binary ~/repos/kmonad/kmonad
else
    set binary $HOME/install/kmonad
    if ! test -f $binary
        # start first kmonad binary found in PATH
        set binary kmonad
    end
end

if test -n "$_flag_config"
    set config $_flag_config
else
    set config ~/.config/kmonad/vou-linux-de-rctrl.kbd
end

if test "$_flag_keyboard" = "all" || string match -q -i "*$_flag_keyboard*" "internal"
    if test -e /dev/input/by-path/platform-i8042-serio-0-event-kbd
        echo "Kill KMonad for internal keyboard"
        pkill -f "kmonad $config"
        if test -z "$_flag_stop"
            echo "Activate KMonad for internal keyboard"
            $binary $config & ; disown
        end
    else
        echo "Device /dev/input/by-path/platform-i8042-serio-0-event-kbd does not exist."
    end
end

set devices \
/dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd \
/dev/input/by-id/usb-413c_Dell_KB216_Wired_Keyboard-event-kbd \
/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd \
/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd \
/dev/input/by-id/usb-Lenovo_Lenovo_Traditional_USB_Keyboard-event-kbd \
/dev/input/by-id/usb-Lite-On_Technology_Corp_HP_USB_Slim_Keyboard_-_Skylab_EU-event-kbd #\
# /dev/input/event8
# /dev/input/by-id/usb-046a_0023-event-kbd

set names \
'Jelly Comb keyboard' \
'Dell keyboard' \
'Royal Kludge keyboard' \
'Keychron K6' \
'Lenovo keyboard' \
'HP keyboard' #\
# 'Cherry keyboard'

# check if Royal Kludge RK61 is available over bluetooth
set RK61 /dev/input/(grep -B 8 -A 4 12001 /proc/bus/input/devices | grep RK-Bluetooth -A 4 | grep -oE 'event[0-9]+')
if string match -q -- "*event*" $RK61
    set --append devices $RK61
    set --append names 'Royal Kludge keyboard over bluetooth'
end

# check if Keychron K6 is available over bluetooth
set KCK6 /dev/input/(grep -B 8 -A 4 12001f /proc/bus/input/devices | grep "Keychron K6" -A 4 | grep -oE 'event[0-9]+')
if string match -q -- "*event*" $KCK6
    set --append devices $KCK6
    set --append names 'Keychron K6 keyboard over bluetooth'
end

for i in (seq (count $devices))
    test -e $devices[$i] || continue
    test "$_flag_keyboard" = "all" || string match -q -i "*$_flag_keyboard*" "$names[$i]" || continue

    echo "Kill KMonad for "$names[$i]
    set dest "/tmp/kmonad-vou-"(string replace -a ' ' '-' $names[$i])".kbd"
    pkill -f "kmonad $dest"
    if test -z "$_flag_stop"
        cp $config $dest
        sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$devices[$i]':' $dest
        if string match -q -- "Keychron K6*" $names[$i]
            # swap "home" and "del" key: replace second occurrence of "home del" with "del home"
            sed -i '0,/home del/! {0,/home del/ s/home del/del home/}' $dest
        end
        echo "Activate KMonad for "$names[$i]
        $binary $dest -l debug >> ~/kmonad.log 2>&1 & ; disown
        # $binary $dest -l debug
    end
end
