#!/bin/sh
line_number=$(($(cat /tmp/line_number)+1)) && printf $line_number > /tmp/line_number
