#!/bin/bash

# dwm statusbar - show current date and time
while true; do
    ~/.config/dwm/update-status.bash

    seconds=$(date +%-S)
    seconds_to_full_minute=$(( 60 - $seconds ))
    # echo "$dat: Sleeping for $seconds_to_full_minute seconds." >> ~/.dwm.sleeping.log
    sleep $seconds_to_full_minute
done &

# fix for bug with floating windows and Java programs
export _JAVA_AWT_WM_NONREPARENTING=1
#export AWT_TOOLKIT=MToolkit
export XDG_SESSION_TYPE=x11

LANG='en_US.UTF-8'

mkdir -p ~/log
msteams_cookies="$HOME/.config/Microsoft/Microsoft Teams/Cookies"
[ -f "$msteams_cookies" ] && rm "$msteams_cookies" 2> /dev/null

PATH="$HOME/bin:$HOME/.local/bin:$PATH"
# Remove /bin and /sbin from PATH (covered by /usr/bin and /usr/sbin).
# This is necessary to have /usr/local/bin before /usr/bin.
PATH="${PATH/:\/sbin:/:}"
PATH="${PATH/:\/bin:/:}"
echo "PATH=$PATH" > ~/log/dwm-start.log

# start dwm
while true; do
    devPixelsPerPxOld=$devPixelsPerPx
    if xrandr | grep -q 3840x2160
    then
        # HiDPI settings for the 4k display in the office
        dpi=$'Xft.dpi: 150\nrofi.dpi: 150'
        devPixelsPerPx=1.1
    elif xrandr | grep -q 2560x1440
    then
        # Peaq (32 inch, WQHD)
        dpi=''
        devPixelsPerPx=1.2
    else
        # (office) laptop display
        dpi=''
        devPixelsPerPx=1.3
    fi
    [ "$devPixelsPerPx" = "$devPixelsPerPxOld" ] && DPI_CHANGED= || DPI_CHANGED=1
    export DPI_CHANGED
    # remove current dpi settings and append $dpi to ~/.Xresources
    sed -i -E '/^(Xft|rofi)\.dpi.*/d' ~/.Xresources
    [ "$dpi" ] && echo "$dpi" >> ~/.Xresources
    if test -e ~/.mozilla/firefox/5c2gkmrd.default-release
    then
        echo "user_pref(\"layout.css.devPixelsPerPx\", \"$devPixelsPerPx\");" > ~/.mozilla/firefox/5c2gkmrd.default-release/user.js
        # Change manually (no restart of Firefox required):
        # Ctrl-Shift-k → Services.prefs.setStringPref("layout.css.devPixelsPerPx", "1.1");
    fi
    xrdb ~/.Xresources
    # [ -f $HOME/.xmodmap ] && xmodmap $HOME/.xmodmap
    xset r rate 300 50
    # Log stderror to a file
    dwm > ~/log/dwm.log 2>&1
    export RESTART=1
done
