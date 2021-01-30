#!/usr/bin/env bash
pid=$(pgrep -f "alacritty -d 82 9 -t Calendar -e bash -c ncal")
test -z $pid && alacritty -d 82 9 -t Calendar -e bash -c 'ncal -bwM3 && printf "Press Enter for closing " && read' || kill $pid
