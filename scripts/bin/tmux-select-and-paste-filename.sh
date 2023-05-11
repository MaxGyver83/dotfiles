#!/bin/sh
tmux-select-filename.sh | tmux load-buffer - && tmux paste-buffer -s " "
