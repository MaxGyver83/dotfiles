#!/usr/bin/env bash
# pid=$(pgrep -f "alacritty -d 82 9 -t Calendar -e bash -c ncal")
# test -z $pid && alacritty -d 82 9 -t Calendar -e bash -c 'ncal -bwM3 && printf "Press Enter for closing " && read' || kill $pid
pid=$(pgrep -f "alacritty -t Calendar")
test -z $pid && WINIT_X11_SCALE_FACTOR=1.0 alacritty -t Calendar -o "window.dimensions.columns=82" -o "window.dimensions.lines=9" -e bash -c 'ncal -bwM3 && printf "Press Enter for closing " && read' || kill $pid
