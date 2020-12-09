numlockx off
#setxkbmap de koy && xkbcomp -w 0 ~/bin/vou-wide-tabwin.xkb $DISPLAY
#~/install/kmonad ~/.config/kmonad/vou4.kbd &
#test -e /dev/input/by-id/usb-Telink_Wireless_Receiver-if01-event-kbd && ~/install/kmonad ~/.config/kmonad/vou4-jellycomb.kbd &
#test -e /dev/input/by-id/usb-You_idobo_0-event-kbd && ~/install/kmonad ~/.config/kmonad/vou2-idobo.kbd &
~/bin/start-kmonad-for-all-keyboards.fish de &
xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
dunst &
xrandr | grep -q 2560x1440 && test -f ~/.screenlayout/peaq.sh && ~/.screenlayout/peaq.sh
xrandr --output $(xrandr | grep -w connected | head -n 1 | cut -d " " -f1) --brightness 0.7
# test -f ~/.screenlayout/ext-monitor-acer.sh && ~/.screenlayout/ext-monitor-acer.sh
test -d /home/max && ~/bin/set-random-wallpaper.bash || feh --bg-fill ~/Pictures/Leo4.jpg
type compton &> /dev/null && compton &
# trayer --widthtype request --align right &
nm-applet &
pasystray &
copyq &
sxhkd &
# ~/bin/beep-on-key.bash enter &
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
#alacritty --config-file ~/.config/alacritty/alacritty_dwm.yml -e byobu &
~/install/alacritty-0.6 --config-file ~/.config/alacritty/alacritty_dwm_0.6.yml -e byobu &
firefox && sleep 1 && wmctrl -a byobu &
