function k --description 'Start KMonad for all available keyboards'
    set config ~/.config/kmonad/vou-linux.kbd
    pkill kmonad

    echo "Activate KMonad for internal keyboard"
    kmonad $config & ; disown

    set keyb /dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd
    if test -e $keyb
        echo "Activate KMonad for Jelly Comb keyboard"
        set dest "/tmp/kmonad-vou-jelly.kbd"
        cp $config $dest
        sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$keyb':' $dest
        kmonad $dest & ; disown
    end

    set keyb /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd
    if test -e $keyb
        echo "Activate KMonad for Royal Kludge keyboard"
        set dest "/tmp/kmonad-vou-royal.kbd"
        cp $config $dest
        sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$keyb':' $dest
        kmonad $dest & ; disown
    end

    set keyb /dev/input/(grep -B 8 -A 4 120013 /proc/bus/input/devices | grep RK-Bluetooth -A 4 | grep -oE 'event[0-9]+')
    if string match -q -- "*event*" $keyb
        echo "Activate KMonad for Royal Kludge keyboard over bluetooth"
        set dest "/tmp/kmonad-vou-royal-bt.kbd"
        cp $config $dest
        sed -i 's:/dev/input/by-path/platform-i8042-serio-0-event-kbd:'$keyb':' $dest
        kmonad $dest & ; disown
    end
end
