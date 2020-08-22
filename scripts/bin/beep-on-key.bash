#!/bin/bash
if [ "$1" = return ]; then
    keycode=36
elif [ "$1" = escape ]; then
    keycode=9
else
    # tab key
    keycode=23
fi
xinput test 12 | while read in ; do [[ $in = "key press   $keycode" ]] && play -q -n synth 0.1 sin 880 2> /dev/null; done
