numlockx off
setxkbmap de koy && xkbcomp -w 0 ~/bin/vou-wide-tabwin.xkb $DISPLAY
xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
dunst &
xrandr | grep -q 2560x1440 && test -f ~/.screenlayout/only-peaq.sh && ~/.screenlayout/only-peaq.sh
# test -f ~/.screenlayout/ext-monitor-acer.sh && ~/.screenlayout/ext-monitor-acer.sh
test -d /home/max && ~/bin/set-random-wallpaper.bash || feh --bg-fill ~/Pictures/Leo3.jpg
type compton &> /dev/null && compton &
# trayer --widthtype request --align right &
nm-applet &
pasystray &
copyq &
sxhkd &
~/bin/beep-on-key.bash enter &
