#!/bin/bash
cd ~/repos/wallpapers > /dev/null 2>&1 || cd ~/Bilder/Wallpaper || exit 1
feh --bg-fill $(fd '.jpg' | sort -R | tail -1)
