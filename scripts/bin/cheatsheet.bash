#!/usr/bin/env bash
pkill -f "alacritty -t Cheatsheet -o" && exit 0

document="${1:-$HOME/.dotfiles/cheatsheets/vim.txt}"

rows=$(wc -l "$document" | cut -d' ' -f1)
rows=$(( rows > 40 ? 40 : rows+1 ))

cols=$(wc -L "$document" | cut -d' ' -f1)
cols=$(( cols > 200 ? 200 : cols+2 ))

# add one empty column as padding
cmd="sed 's/^/ /' $document | grep --color=always -P '^.*?  |' | LESS='iR#2K' less"

WINIT_X11_SCALE_FACTOR=1.0 alacritty -t Cheatsheet \
  -o "window.dimensions.columns=$cols" -o "window.dimensions.lines=$rows" \
  -o "font.size=14.0" -o "colors.primary.background='#fcfc90'" \
  -o "colors.primary.foreground='#000000'" -e bash -c "$cmd"
