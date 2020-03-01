# bind = bind-key
# unbind = unbind-key
# send = send-keys
# (un)bind -n = no prefix needed

# replace regular prefix key (C-a) with C-f
unbind -n C-a
unbind -n C-f
set -g prefix ^F
set -g prefix2 F12
# Ctrl-f f = send Ctrl-f
bind f send-prefix

# Ctrl-f Ctrl-f = toggle window
bind C-f last-window

# Ctrl-PageUp/PageDown for previous/next window
# needs to be unset in terminator
bind -n C-PPage previous-window
bind -n C-NPage next-window

# Alt-Left and Alt-Right for previous/next pane
unbind -n M-Up
unbind -n M-Down
bind -n M-Up display-panes \; select-pane -t :.-
bind -n M-Down display-panes \; select-pane -t :.+

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
