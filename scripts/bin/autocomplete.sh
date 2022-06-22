#!/bin/sh

# select line from ~/.snippets with rofi, replace '\n's by newlines, trim the final newline,
# and write to both primary selection and clipboard (because Firefox pastes the clipboard on Shift-Insert)
# rofi -i -dmenu $@ < /usr/share/dict/words | head -c -1 | xclip -i -sel p -f | xclip -i -sel c
xdotool key shift+ctrl+Left
sleep 0.1
# xdotool key right
rofi -i -matching regex -filter "^$(xclip -o)" -dmenu $@ < /usr/share/dict/words | head -c -1 | xclip -i -sel p -f | xclip -i -sel c
sleep 0.1
xdotool key shift+Insert
