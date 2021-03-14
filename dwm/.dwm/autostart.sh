#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    echo Run: $@
    $@&
  fi
}

# numlockx off
~/bin/start-kmonad-for-all-keyboards.fish de2 &
#xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
run dunst
xrandr | grep -q 2560x1440 && ~/.screenlayout/peaq-usb.sh || ~/.screenlayout/peaq.sh
# [ $(xrandr | grep -wc connected) -eq 3 ] && ~/.screenlayout/2-externe-acer.sh
xrandr --output $(xrandr | grep -w connected | head -n 1 | cut -d " " -f1) --brightness 0.7
# test -f ~/.screenlayout/ext-monitor-acer.sh && ~/.screenlayout/ext-monitor-acer.sh
~/bin/set-wallpaper.bash
# compton: `--focus...` is needed to not dim the status bar and rofi
[ pgrep -f compton ] || compton --inactive-dim 0.2 --focus-exclude 'x = 0 && y = 0 && override_redirect = true || class_g = "Rofi"' &
# trayer --widthtype request --align right &
run nm-applet
run pasystray
run blueman-manager
run copyq
run sxhkd
run xbanish -i shift -i control -i mod1 -i mod4
# ~/bin/beep-on-key.bash enter &
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# start Alacritty with byobu and Firefox if not yet running
if ! pgrep -f "$HOME/install/alacritty -e byobu" ; then
  run ~/install/alacritty -e byobu
fi
if ! pgrep -f firefox ; then
  firefox &
  sleep 1
  wmctrl -a byobu
fi
