#!/usr/bin/env bash

function run {
  if ! pgrep -f "$1" ;
  then
    echo Run: $@
    $@&
  fi
}

# Get rid of some dbind warnings.
# See https://unix.stackexchange.com/a/230442/305474
export NO_AT_BRIDGE=1

wmctrl -m | grep -q bspwm && WM=bspwm

# numlockx off
~/bin/start-kmonad.fish --keyboard all &
#xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
run dunst
if [ "$WM" != bspwm ]; then
  xrandr | grep -q 2560x1440 && ~/.screenlayout/peaq.sh
  xrandr | grep -q 3440x1440 && ~/.screenlayout/dell.sh
  [ $(xrandr | grep -wc connected) -eq 3 ] && ~/.screenlayout/2x-acer.sh
fi
# set first (=laptop) display to 70% brightness
xrandr --output $(xrandr | grep -w connected | head -n 1 | cut -d " " -f1) --brightness 0.7
# test -f ~/.screenlayout/ext-monitor-acer.sh && ~/.screenlayout/ext-monitor-acer.sh
~/bin/set-wallpaper.bash
# run trayer only in bspwm
[ "$WM" = bspwm ] && run trayer --edge top --align right --margin 220 --widthtype request --height 28 --tint 0x292b2e --transparent true --expand true --SetDockType true --alpha 0
# compton: `--focus...` is needed to not dim the status bar and rofi
pgrep -f compton > /dev/null 2>&1 || compton &
run nm-applet
run pasystray
run blueman-applet
run copyq
# start sxhkd if not running bspwm
[ "$WM" = bspwm ] || run sxhkd
# run xbanish -i shift -i control -i mod1 -i mod4
# ~/bin/beep-on-key.bash enter &
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# start st with tmux and Firefox if not yet running
tmux has-session -t 0 && run 'st -e tmux a -t 0' || st -e tmux &
if ! pgrep -f firefox ; then
  firefox &
  sleep 1
  echo "Focus tmux:"
  wmctrl -a tmux
fi
