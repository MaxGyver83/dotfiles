#!/bin/sh

# This file needs to be sourced!
if [ "$TMUX" ]; then
    tmux_display="$(tmux show-env | sed -n s/^DISPLAY=//p)"
    if [ "$DISPLAY" = "$tmux_display" ]; then
        echo "$DISPLAY"
    else
        echo "before:     $DISPLAY
updated to: $tmux_display"
        DISPLAY="$tmux_display"
    fi
    unset tmux_display
else
    echo "$DISPLAY"
fi
