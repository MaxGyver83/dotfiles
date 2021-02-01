#!/usr/bin/env bash
pid=$(pgrep -f "alacritty.*-t Cheatsheet")
if [ -z "$pid" ] ; then
  rows=$(wc -l ~/bin/cheatsheet.txt | cut -d' ' -f1)
  rows=$((rows + 1))
  cols=$(wc -L ~/bin/cheatsheet.txt | cut -d' ' -f1)
  # ~/install/alacritty-0.6 --config-file ~/.config/alacritty/alacritty_dwm_0.6.yml -t Cheatsheet -d $cols $rows -e bash -c 'cat ~/bin/cheatsheet.txt && read' &
  WINIT_X11_SCALE_FACTOR=1.0 ~/install/alacritty-0.7.1 -t Cheatsheet -o "window.dimensions.columns=$cols" -o "window.dimensions.lines=$rows" -e bash -c 'cat ~/bin/cheatsheet.txt && read'
else
  kill $pid
fi
