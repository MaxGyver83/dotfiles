test -d /home/max && feh --bg-fill ~/Bilder/Wallpaper/SeaSunset.jpg || feh --bg-fill ~/Pictures/Leo3.jpg
numlockx off
setxkbmap de koy && xkbcomp -w 0 ~/bin/vou-tab.xkb $DISPLAY
xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
sxhkd &
dunst &
#st -e fish &

