#!/bin/sh
tmux capture-pane -p -S 0 | tac | grep -oP '(~/)?[./[:alnum:]_-]*[./][./[:alnum:]_-]+|\(\K\w+(?=|)' | awk 'length($0)>5 && !x[$0]++' | fzf --no-sort
