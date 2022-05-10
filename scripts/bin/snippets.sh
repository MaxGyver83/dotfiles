#!/bin/sh

# select line from ~/.snippets with rofi, replace '\n's by newlines, trim the final newline,
# and write to both primary selection and clipboard (because Firefox pastes the clipboard on Shift-Insert)
rofi -i -dmenu $@ < ~/.snippets | sed 's/\\n/\n/g' | head -c -1 | xclip -i -sel p -f | xclip -i -sel c
sleep 0.1
xdotool key shift+Insert
