#!/bin/sh
# if [ $# -lt 1 ]; then exit 1; fi
test -f /tmp/line_number || exit 1
line_number=$(cat /tmp/line_number)
tmux send C-u
test $line_number -eq 0 && exit 0
tail -n $line_number /tmp/tmux_buffer | head -n 1 | tr "\n" " " | tmux load-buffer - && tmux paste-buffer -s " "
