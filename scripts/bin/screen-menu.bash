#!/usr/bin/env bash

# when called with option -w, run this script in a new alacritty window
if [ $# -ge 1 ] && [ "$1" = "-w" ]; then
  pid=$(pgrep -f "alacritty -t 'Screen menu'")
  test -z $pid && WINIT_X11_SCALE_FACTOR=1.0 alacritty -t "Screen menu" -o "window.dimensions.columns=30" -o "window.dimensions.lines=8" -e "$0" || kill $pid
  exit 0
fi

options='
l Laptop only
p Peaq only
P Peaq + Laptop
d Dell only
D Dell + Laptop
a Acers only
A Acers + Laptop
'

# print first letter of each line in red
bold=$(tput bold)
red=$(tput setaf 1)
normal=$(tput sgr0)
options=$(echo "$options" | sed -e "s/\(^.\)/${red}${bold}\1${normal}/")

echo -e "Select an option:\n$options"
read -rsn1 key

case $key in
  l) ~/.screenlayout/laptop.sh ;;
  p) ~/.screenlayout/peaq.sh ;;
  P) ~/.screenlayout/laptop-peaq.sh ;;
  d) ~/.screenlayout/dell.sh ;;
  D) ~/.screenlayout/laptop-dell.sh ;;
  a) ~/.screenlayout/2x-acer.sh ;;
  A) ~/.screenlayout/laptop-2x-acer.sh ;;
  *) echo Canceled. ; exit 1 ;;
esac

# reset background image
~/.fehbg
