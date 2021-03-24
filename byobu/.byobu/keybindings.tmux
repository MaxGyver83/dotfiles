# bind = bind-key
# unbind = unbind-key
# send = send-keys
# (un)bind -n = no prefix needed

# replace regular prefix key (C-a) with C-e
unbind -n C-a
unbind -n C-e
set -g prefix ^E
set -g prefix2 F12
# Ctrl-e e = send Ctrl-e
bind e send-prefix

# Ctrl-e Ctrl-e = toggle window
unbind C-a
bind C-e last-window

# Ctrl-PageUp/PageDown for previous/next window
# needs to be unset in terminator
bind -n C-PPage previous-window
bind -n C-NPage next-window
bind -n M-a previous-window
bind -n M-i next-window
# Shift-Ctrl-PageUp/PageDown: move window left/right
bind -n S-C-PPage swap-window -d -t:-1
bind -n S-C-NPage swap-window -d -t:+1

# Unbind Alt-Left and Alt-Right for previous/next window
unbind -n M-Left
unbind -n M-Right

# Unbind Shift-ArrowKey for switching panes
unbind -n S-Left
unbind -n S-Right
unbind -n S-Up
unbind -n S-Down

# Alt-Up and Alt-Down for previous/next pane
# unbind -n M-Up
# unbind -n M-Down
# bind -n M-Up display-panes \; select-pane -t :.-
# bind -n M-Down display-panes \; select-pane -t :.+

unbind Space
bind Space next-layout
bind -n M-Space next-layout

unbind %
unbind |
unbind -
# split vertically (left/right) |
bind | split-window -h -c "#{pane_current_path}"
# split horizontally (top/bottom) -
bind - split-window -v -c "#{pane_current_path}"
# delete buffer (was before -)
bind % delete-buffer

# scroll only half pages with Alt-PageUp/PageDown
unbind -n M-NPage
unbind -n M-PPage
bind -n M-NPage copy-mode \; send C-d
bind -n M-PPage copy-mode \; send C-u

# activate Home and End in copy-mode
bind -T copy-mode-vi Home send -X start-of-line
bind -T copy-mode-vi End  send -X end-of-line

# switch , and ; in vi mode
unbind -T copy-mode-vi ,
unbind -T copy-mode-vi \;
bind -T copy-mode-vi ,  send -X jump-again
bind -T copy-mode-vi \; send -X jump-reverse

# quit copy mode with x (besides q)
bind -T copy-mode-vi x  send -X cancel

# reload this file
bind R source ~/.byobu/keybindings.tmux \; display "Reloaded keybindings.tmux!"

# send minimal bash config
bind b send "bind 'set completion-ignore-case on' '\"\\t\": menu-complete' '\"\\e[Z\": menu-complete-backward' 'set menu-complete-display-prefix on' && alias gd='git diff' && test -f /tmp/.vimrc && alias vim='vim -u /tmp/.vimrc' && alias vimdiff='vimdiff -u /tmp/.vimrc'"
# send small bash config
bind B send "bind '\"\\e[A\": history-search-backward' '\"\\e[B\": history-search-forward' '\"\\e[1;2D\": shell-backward-word' '\"\\e[1;2C\": shell-forward-word' '\"\\C-b\": shell-backward-word' '\"\\C-f\": shell-forward-word' 'set completion-ignore-case on' '\"\\t\": menu-complete' '\"\\e[Z\": menu-complete-backward' 'set show-all-if-ambiguous on' 'set menu-complete-display-prefix on' && alias ..='cd ..' && alias ...='cd ../..' && alias ....='cd ../../..' && alias .....='cd ../../../..' && alias gd='git diff' && test -f /tmp/.vimrc && alias vim='vim -u /tmp/.vimrc' && alias vimdiff='vimdiff -u /tmp/.vimrc'"

###########################################################
# dwm-inspired tiling pane management
# originally from: https://github.com/saysjonathan/dwm.tmux

# Create new pane in current directory
bind -n M-n split-window -t :.1 -c "#{pane_current_path}" \;\
        swap-pane -s :.1 -t :.2 \;\
        select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\""

# Kill pane
bind -n M-q kill-pane -t :. \;\
        select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\"" \;\
        select-pane -t :.1

# Next/prev pane
bind -n M-e select-pane -t :.+
bind -n M-o select-pane -t :.-

# Resize pane
bind -n M-l resize-pane -L 2
bind -n M-h resize-pane -R 2

# Rotate counterclockwise/clockwise
bind -n M-, rotate-window -U \; select-pane -t 1
bind -n M-x rotate-window -D \; select-pane -t 1

# Focus selected pane
# bind -n M-d swap-pane -d -s :. -t :.1 # \; select-pane -t :.1
bind -n M-w swap-pane -s :. -t !
bind -n M-t if-shell "[ $(tmux display -p '#P') = '1' ]" "swap-pane -d -s :. -t :.1" "swap-pane -s :. -t !"

# Refresh layout
bind -n M-S-r select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\""

# Zoom selected pane
unbind M-m
bind -n M-m resize-pane -Z

# focus last window
bind -n M-t last-window

# create new window
bind -n M-c new-window

# copy line (without leading spaces and newline) into command line
bind -T copy-mode-vi X send -X back-to-indentation \; send -X begin-selection \; send -X end-of-line \; send -X cursor-left \; send -X copy-pipe-and-cancel "tmux paste-buffer"

# browse output lines: Activate with Alt-1, go up/down with Alt-2/3
bind -n M-1 run '~/bin/tmux-save-output.sh'
bind -n M-2 run '~/bin/tmux-increase-line-number.sh && ~/bin/tmux-paste-output-line.sh'
bind -n M-3 run '~/bin/tmux-decrease-line-number.sh && ~/bin/tmux-paste-output-line.sh'
