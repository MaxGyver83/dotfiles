#!/bin/sh
line_number=$(($(cat /tmp/line_number)-1))
[ $line_number -ge 0 ] || line_number=0
printf $line_number > /tmp/line_number
