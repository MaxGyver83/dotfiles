#!/usr/bin/env bash
pkill -f "alacritty -t Cheatsheet -o" && exit 0

document="${1:-$HOME/.dotfiles/cheatsheets/vim.txt}"

rows=$(wc -l "$document" | cut -d' ' -f1)
rows=$(( rows > 40 ? 40 : rows+1 ))

cols=$(wc -L "$document" | cut -d' ' -f1)
cols=$(( cols < 19 ? 20 : cols+2 ))
cols=$(( cols > 200 ? 200 : cols+2 ))

if [ $USE_LESS ]; then
  # add one empty column as padding
  cmd="sed 's/^/ /' $document | grep --color=always -P '^.*?  |' | LESS='iR#2K' less"
else
  # open in vim
  PATH="$HOME/install:$PATH"
  vim_settings="map q :q<cr> | set nonumber | set noshowmode | set noruler \
   | set laststatus=0 | set clipboard+=unnamedplus \
   | set noshowcmd | let g:buftabline_show = 1 \
   | syn match Statement /^.\\{-}  / \
   | syn match Structure /^#.*/ | hi Normal ctermbg=NONE"
  cmd="cd \"\$(dirname $document)\" && nvim -c '$vim_settings' $document"
fi

WINIT_X11_SCALE_FACTOR=1.0 alacritty -t Cheatsheet \
  -o "window.dimensions.columns=$cols" -o "window.dimensions.lines=$rows" \
  -o "font.size=14.0" $YELLOW -e bash -c "$cmd"
#  -o "window.padding.x=10" -o "window.padding.y=10" -o "colors.primary.background='#000000'" \
