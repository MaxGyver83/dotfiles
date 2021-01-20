#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

# numlockx off
~/bin/start-kmonad-for-all-keyboards.fish de &
xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
run dunst
# xrandr | grep -q 2560x1440 && ~/.screenlayout/peaq.sh || ~/.screenlayout/peaq-usb.sh
# [ $(xrandr | grep -wc connected) -eq 3 ] && ~/.screenlayout/2-externe-acer.sh
xrandr --output $(xrandr | grep -w connected | head -n 1 | cut -d " " -f1) --brightness 0.7
# test -f ~/.screenlayout/ext-monitor-acer.sh && ~/.screenlayout/ext-monitor-acer.sh
test -d /home/max && ~/bin/set-random-wallpaper.bash || feh --bg-fill ~/Pictures/Leo4.jpg
run compton
# trayer --widthtype request --align right &
run nm-applet
run pasystray
run copyq
run sxhkd
# ~/bin/beep-on-key.bash enter &
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# start Alacritty with byobu and Firefox if not yet running
run ~/install/alacritty-0.6 --config-file ~/.config/alacritty/alacritty_dwm_0.6.yml -e byobu
if ! pgrep -f firefox ; then
  firefox &
  sleep 1
  wmctrl -a byobu
fi
