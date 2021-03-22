#!/bin/sh
printf 0 > /tmp/line_number
# skip empty lines, trim lines, skip prompt lines, skip virtual env lines:
tmux capture-pane -p | awk /./ | awk '{$1=$1;print}' | sed /▶/d | sed /\(ansi/d > /tmp/tmux_buffer
