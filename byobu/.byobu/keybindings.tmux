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
bind b send "bind '\"\\e[A\": history-search-backward' '\"\\e[B\": history-search-forward' '\"\\C-b\": shell-backward-word' '\"\\C-f\": shell-forward-word' 'set completion-ignore-case on' '\"\\t\": menu-complete' '\"\\e[Z\": menu-complete-backward' 'set show-all-if-ambiguous on' 'set menu-complete-display-prefix on' && alias ..='cd ..' && alias ...='cd ../..' && alias ....='cd ../../..' && alias .....='cd ../../../..' && test -f /tmp/.vimrc && alias vim='vim -u /tmp/.vimrc'"

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
bind -n M-t select-pane -t :.+
bind -n M-r select-pane -t :.-

# Resize pane
bind -n M-l resize-pane -L
bind -n M-h resize-pane -R

# Rotate counterclockwise/clockwise
bind -n M-, rotate-window -U \; select-pane -t 1
bind -n M-S-, rotate-window -D \; select-pane -t 1

# Focus selected pane
bind -n M-i swap-pane -d -s :. -t :.1 # \; select-pane -t :.1
bind -n M-I swap-pane -s :. -t !
bind -n M-e if-shell "[ $(tmux display -p '#P') = '1' ]" "swap-pane -d -s :. -t :.1" "swap-pane -s :. -t !"

# Refresh layout
bind -n M-S-r select-layout main-vertical \;\
        run "tmux resize-pane -t :.1 -x \"$(echo \"#{window_width}/2/1\" | bc)\""

# Zoom selected pane
unbind M-m
bind -n M-m resize-pane -Z
