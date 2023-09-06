#!/usr/bin/env sh

exists() {
  command -v "$1" > /dev/null 2>&1
}

timestamp() {
  date "+%Y-%m-%d %H:%M:%S.%3N"
}

run() {
  if ! pgrep -fa "$1"
  then
    echo "$(timestamp) Run: $@"
    $@&
  fi
}

restart() {
  if [ $RESTART ]; then
    if [ $DPI_CHANGED ]; then
      # restart $1 if it's already running
      pkill "$1" && action=Restart || return
    else
      echo "$(timestamp) WM restarted, no DPI change: Ignore '$@'."
      return
    fi
  else
    action=Run
  fi
  echo "$(timestamp) $action: $@"
  $@&
}

echo "RESTART=$RESTART"
echo "DPI_CHANGED=$DPI_CHANGED"

# Get rid of some dbind warnings.
# See https://unix.stackexchange.com/a/230442/305474
export NO_AT_BRIDGE=1

PATH="$PATH:~/.local/bin"

# numlockx off
~/bin/start-kmonad.fish --keyboard all &
#xset r rate 300 50
#xinput set-prop 'ETPS/2 Elantech Touchpad' 'libinput Natural Scrolling Enabled' 1
restart dunst
echo "$(timestamp) Switch to external screen (if available)"
if [ "$(hostname)" = 'max-laptop' ]; then
  [ "$(head -1 /sys/class/drm/card0-DP-1/modes)" = '2560x1440' ] || [ "$(head -1 /sys/class/drm/card1-DP-1/modes)" = '2560x1440' ] && ~/.screenlayout/layout.sh external
elif xrandr | grep -q 3840x2160 ; then
  ~/.screenlayout/layout.sh external 4K
elif xrandr | grep -q 2560x1440 ; then
  ~/.screenlayout/layout.sh external
  # [ $(xrandr | grep -wc connected) -eq 3 ] && ~/.screenlayout/2x-acer.sh
fi
# echo "$(timestamp) Set first (=laptop) display to 70% brightness"
# set first (=laptop) display to 70% brightness
# xrandr --output $(xrandr | grep -w connected | head -n 1 | cut -d " " -f1) --brightness 0.7
# test -f ~/.screenlayout/ext-monitor-acer.sh && ~/.screenlayout/ext-monitor-acer.sh
run /bin/sh ~/bin/set-wallpaper.bash
if exists picom ; then
  run picom
elif exists compton ; then
  # compton: `--focus...` is needed to not dim the status bar and rofi
  run compton
fi
run nm-applet
run pasystray
run blueman-applet
restart copyq
run sxhkd
internxt="$(\ls ~/install/Internxt-Drive-* | head -n 1)"
[ "$internxt" ] && run "$internxt"
# run xbanish -i shift -i control -i mod1 -i mod4
# ~/bin/beep-on-key.bash enter &
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# ( export TERM=dumb
# if [[ "$(uname -n)" == c* ]]; then
#   # when at home and eth0 is up, disable wlan0 and start vpn
#   if iwgetid | grep -q Yippie && ip -4 a | grep -q 'eth0.*state UP'; then
#     nmcli d disconnect wlan0
#     /lhome/schimax/bin/vpn
#   fi
# fi ) &

# start st with tmux and Firefox if not yet running
if ! pgrep -a '^st$' ; then
  tmux has-session -t 0 && run 'st -e tmux a -t 0' || st -e tmux &
fi
restart firefox
echo "$(timestamp) Sleep for 1 second"
sleep 1
echo "$(timestamp) Focus tmux:"
wmctrl -a tmux

echo "$(timestamp) autostart.sh done"
