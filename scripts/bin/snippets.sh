#!/bin/sh

selection=$(rofi -i -dmenu $@ < ~/.snippets)
echo -n "$selection" | xclip
sleep 0.1
xdotool key shift+Insert
