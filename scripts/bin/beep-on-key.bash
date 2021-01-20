#!/bin/bash
if [ "$1" = return ] || [ "$1" = enter ]; then
    keycode=36
elif [ "$1" = escape ]; then
    keycode=9
elif [ "$1" = backspace ]; then
    keycode=22
else
    # default: tab key
    keycode=23
fi
xinput test 14 | while read in ; do [[ $in = "key press   $keycode" ]] && play -q -n synth 0.1 sin 880 2> /dev/null; done
