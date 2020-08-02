#!/bin/sh
# Jump to vim:
# - no vim open: create a new byobu window and start vim (and focus it)
# - only 1 vim instance open: jump to it
# - 2 or more vim instances open
#    - byobu is not active but vim is active in byobu: jump to byobu (and stay in current window)
#    - vim is not active in byobu: jump to next vim instance
#    - vim is active: jump to next (other) vim instance

byobu_active=$(xdotool getactivewindow getwindowname | grep -c byobu)

# exit if switched to vim successfully
jumpapp -t byobu alacritty -e byobu && tmux select-window -t vim 2>/dev/null && exit 0

# If byobu wasn't running, it has been started now.
# If byobu was already running, there was no vim window or more than one.

# list of vim windows (tmux window index) reordered, starting after the current window
vim_windows=$({ tmux list-windows | sed -n '/active/,$p' | sed 1d & tmux list-windows | sed '/active/Q'; } | grep vim | awk -F: '{print $1}')

if [ -z "$vim_windows" ] ; then
    # if there are no open vim sessions, start a new one
    # (using 'bash -ic' because otherwise Ctrl-q doesn't work in vim)
    tmux new-window -c ~ 'bash -ic vim'
else
    # if coming from outside byobu and vim is already focused, exit
    vim_active=$(tmux list-windows | grep -c 'vim.*(active)')
    if [ "$byobu_active" = 0 ] && [ "$vim_active" = 1 ]; then exit 0; fi

    # select the next available vim window (of two or more)
    for window_index in $vim_windows; do
        tmux select-window -t "$window_index"; exit 0
    done
fi
