#!/bin/sh

# Execute snippets.sh for rofi or snippets-dmenu.sh (symlink) for dmenu
if [ ${0##*/} = 'snippets-dmenu.sh' ]; then
    linecount=$(cat ~/.snippets | wc -l)
    # dmenu with center patch
    cmd="dmenu -i -c -l $linecount -fn monospace:size=14"
elif [ ${0##*/} = 'snippets-dmenu1.sh' ]; then
    SNIPPETS=~/.snippets1
    linecount=$(cat $SNIPPETS | wc -l)
    # dmenu with center patch and instant_first_char patch
    cmd="dmenu -1 -c -l $linecount -fn monospace:size=14"
else
    cmd='rofi -i -dmenu -kb-cancel Escape,Control+c,Control+g'
fi

# select line from ~/.snippets with rofi or dmenu, replace '\n's by newlines,
# trim the final newline, and write to both primary selection and clipboard
# (because Firefox pastes the clipboard on Shift-Insert)
$cmd $@ < ${SNIPPETS:-~/.snippets} \
    | sed 's/^. //' \
    | sed 's/\\n/\n/g' \
    | head -c -1 \
    | xclip -i -sel p -f \
    | xclip -i -sel c
sleep 0.1
xdotool key shift+Insert
