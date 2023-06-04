#!/usr/bin/env bash
pid=$(pgrep -f "alacritty.*-t Cheatsheet")
if [ -z "$pid" ] ; then
  # rows=$(wc -l ~/bin/cheatsheet.txt | cut -d' ' -f1)
  # rows=$((rows + 1))
  rows=45
  cols=$(wc -L ~/bin/cheatsheet.txt | cut -d' ' -f1)
  WINIT_X11_SCALE_FACTOR=1.0 ~/install/alacritty -t Cheatsheet -o "window.dimensions.columns=$cols" -o "window.dimensions.lines=$rows" -e bash -c 'less ~/bin/cheatsheet.txt'
else
  kill $pid
fi
