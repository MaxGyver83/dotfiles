#!/usr/bin/env fish
set last_command (string split --max 1 ' ' $history[2])
set cmd $last_command[1]
set args $last_command[2]
if [ $cmd != 'rg' ]
    echo "The last command did not start with 'rg'!"
    echo ---$cmd---
    echo ---$last_command---
    exit 1
end

echo nvim -c "execute 'RgRaw $args'"
nvim -c "execute 'RgRaw "(string replace -a "'" "" $args)"'"
