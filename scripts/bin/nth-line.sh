#!/bin/bash
line_number="${1:-1}"
file=~/kmonad.log

time { tail -n+${line_number} $file | head -n1; }
time { head -n${line_number} $file | tail -1; }
time { sed "${line_number}q;d" $file; }
time { sed -n "${line_number}p" $file; }
time { sed "${line_number}!d" $file; }
