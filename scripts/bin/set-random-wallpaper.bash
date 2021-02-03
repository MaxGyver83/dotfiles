#!/bin/bash
cd ~/repos/wallpapers || ~/Bilder/Wallpaper || exit 1
feh --bg-fill $(fd '.jpg' | sort -R | tail -1)
