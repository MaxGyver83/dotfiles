#!/usr/bin/env bash

# Source:
# https://unix.stackexchange.com/questions/89538/how-to-tell-which-keyboard-was-used-to-press-a-key
# Another very similar solution:
# https://gitlab.com/victor-engmark/which-keyboard

set -o errexit -o nounset -o noclobber -o pipefail

# Remove leftover files and processes on exit
trap 'rm --recursive -- "$dir"; kill -- -$$' EXIT
dir="$(mktemp --directory)"
cd "$dir"

# Log key presses to file
xinput --list --id-only | while read id
do
    # Only check devices linked to an event source
    if xinput --list-props "$id" | grep --quiet --extended-regexp '^\s+Device Node.*/dev/input/event'
    then
        xinput test "$id" > "$id" &
    fi
done

# Check for key presses
while sleep 0.1
do
    for file in *
    do
        if [[ -s "$file" ]]
        then
            echo "$file"
            exit
        fi
    done
done
