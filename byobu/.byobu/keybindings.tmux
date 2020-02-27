unbind-key -n C-a
unbind-key -n C-f
set -g prefix ^F
set -g prefix2 F12
bind f send-prefix

# Ctrl-f Ctrl-f = toggle window
bind ^F last-window

# Alt-Left and Alt-Right for previous/next pane
unbind -n M-Up
unbind -n M-Down
bind-key -n M-Up display-panes \; select-pane -t :.-
bind-key -n M-Down display-panes \; select-pane -t :.+

# split vertically (left/right) |
unbind |
bind | split-window -h -c "#{pane_current_path}"

# split horizontally (top/bottom) %
unbind %
bind % split-window -v -c "#{pane_current_path}"

# scroll only half pages with Alt-PageUp/PageDown
unbind -n M-NPage
unbind -n M-PPage
bind-key -n M-NPage copy-mode \; send-keys C-d
bind-key -n M-PPage copy-mode \; send-keys C-u
