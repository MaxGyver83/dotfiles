#!/bin/sh
tmux capture-pane -p -S 0 | tac | grep -oP '(~/)?[./[:alnum:]_-]*[./][./[:alnum:]_-]+' | awk 'length($0)>5 && !x[$0]++' | fzf --multi --no-sort
