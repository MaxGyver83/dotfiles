#!/usr/bin/fish

contains ~/install $fish_user_paths || set -Up fish_user_paths ~/install
if test "$argv[1]" = "de"
    set config ~/.config/kmonad/vou-linux-de.kbd
    set binary kmonad
else if test "$argv[1]" = "de2"
    set config ~/.config/kmonad/vou-linux-de-rctrl.kbd
    set binary kmonad
else if test "$argv[1]" = "test"
    set config ~/.config/kmonad/vou-linux-de.kbd
    set binary ~/repos/kmonad/kmonad
else
    set config ~/.config/kmonad/vou-linux.kbd
    set binary kmonad
end
pkill run_forever
pkill try_three_times
pkill '^kmonad'

echo "Activate KMonad for internal keyboard"
$binary $config & ; disown

# set keyb /dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd
# if test -e $keyb
#     echo "Activate KMonad for Jelly Comb keyboard"
#     set dest "/tmp/kmonad-vou-jelly.kbd"
#     cp $config $dest
#     sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$keyb':' $dest
#     $binary $dest & ; disown
# end

# set keyb /dev/input/by-id/usb-413c_Dell_KB216_Wired_Keyboard-event-kbd
# if test -e $keyb
#     echo "Activate KMonad for Dell keyboard"
#     set dest "/tmp/kmonad-vou-dell.kbd"
#     cp $config $dest
#     sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$keyb':' $dest
#     $binary $dest & ; disown
# end

set keyb /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd
if test -e $keyb
    echo "Activate KMonad for Royal Kludge keyboard"
    set dest "/tmp/kmonad-vou-royal.kbd"
    cp $config $dest
    sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$keyb':' $dest
    # $binary $dest & ; disown
    run_forever.fish $binary $dest & ; disown
end

set keyb /dev/input/(grep -B 8 -A 4 12001 /proc/bus/input/devices | grep RK-Bluetooth -A 4 | grep -oE 'event[0-9]+')
if string match -q -- "*event*" $keyb
    echo "Activate KMonad for Royal Kludge keyboard over bluetooth"
    set dest "/tmp/kmonad-vou-royal-bt.kbd"
    cp $config $dest
    sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$keyb':' $dest
    # $binary $dest -l debug >> ~/kmonad.log & ; disown
    run_forever.fish $binary $dest & ; disown
end
