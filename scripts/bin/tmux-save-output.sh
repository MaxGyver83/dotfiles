#!/bin/sh
printf 0 > /tmp/line_number
# skip empty lines, trim lines, skip prompt lines, skip virtual env lines, keep only file names in ll output:
tmux capture-pane -p \
  | awk /./ \
  | awk '{$1=$1;print}' \
  | sed /▶/d \
  | sed /\(ansi/d \
  | sed -E 's/^[dl-][r-][w-][x-][^[:space:]]+ ([^[:space:]]+ ){7}//' \
  | sed -E '/^\.\.?\/?/d' \
  > /tmp/tmux_buffer
