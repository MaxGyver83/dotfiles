#!/bin/sh
printf 0 > /tmp/line_number
# skip empty lines, trim lines, remove prompts, skip virtual env lines, keep only file names in ll output, remove ./ and ../, delete trailing ^C, delete adjacent duplicate lines:
tmux capture-pane -p \
  | awk /./ \
  | awk '{$1=$1;print}' \
  | sed -E 's/^.*?▶ *//' \
  | awk /./ \
  | sed /^\(ansi/d \
  | sed -E 's/^[dl-][r-][w-][x-][^[:space:]]+ ([^[:space:]]+ ){7}//' \
  | sed -E '/^\.\.?\/?/d' \
  | sed -E 's/\^C$//' \
  | uniq \
  > /tmp/tmux_buffer
