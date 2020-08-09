feh --bg-scale /home/max/Bilder/Wallpaper/SeaSunset.jpg
setxkbmap de kou && xkbcomp -w 0 ~/bin/vou-tab.xkb $DISPLAY
xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
sxhkd &
dunst &
