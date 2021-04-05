#!/usr/bin/fish
argparse 'c/config=' 'k/keyboard=' 't/test' 's/stop' -- $argv

if test -z "$_flag_keyboard"
    echo "\
Usage:  start-kmonad.fish OPTIONS

OPTIONS:
  -k, --keyboard  For example: all, internal, Dell, Jelly, Royal, bluetooth [mandatory]
  -c, --config    KMonad config file [default: ~/.config/kmonad/vou-linux-de-rctrl.kbd]
  -s, --stop      Stop KMonad for the given keyboard
  -t, --test      Run ~/repos/kmonad/kmonad (instead of kmonad from PATH)
"
    exit 1
end

if test -n "$_flag_test"
    set binary ~/repos/kmonad/kmonad
else
    set binary kmonad
end

if test -n "$_flag_config"
    set config $_flag_config
else
    set config ~/.config/kmonad/vou-linux-de-rctrl.kbd
end

if test "$_flag_keyboard" = "all" || string match -q -i "*$_flag_keyboard*" "internal"
    echo "Kill KMonad for internal keyboard"
    pkill -f "^$binary $config"
    if test -z "$_flag_stop"
        echo "Activate KMonad for internal keyboard"
        $binary $config & ; disown
    end
end

set devices \
/dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd \
/dev/input/by-id/usb-413c_Dell_KB216_Wired_Keyboard-event-kbd \
/dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd

set names \
'Jelly Comb keyboard' \
'Dell keyboard' \
'Royal Kludge keyboard'

# check if Royal Kludge RK61 is available over bluetooth
set RK61 /dev/input/(grep -B 8 -A 4 12001 /proc/bus/input/devices | grep RK-Bluetooth -A 4 | grep -oE 'event[0-9]+')
if string match -q -- "*event*" $RK61
    set --append devices $RK61
    set --append names 'Royal Kludge keyboard over bluetooth'
end

for i in (seq (count $devices))
    test "$_flag_keyboard" = "all" || string match -q -i "*$_flag_keyboard*" "$names[$i]" || continue

    echo "Kill KMonad for "$names[$i]
    set dest "/tmp/kmonad-vou-"(string replace -a ' ' '-' $names[$i])".kbd"
    pkill -f "^$binary $dest"
    if test -z "$_flag_stop"
        cp $config $dest
        sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$devices[$i]':' $dest
        echo "Activate KMonad for "$names[$i]
        $binary $dest -l debug >> ~/kmonad.log 2>&1 & ; disown
        # $binary $dest -l debug
    end
end
