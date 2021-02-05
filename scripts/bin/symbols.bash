#!/usr/bin/env bash
~/install/alacritty -t Symbols -o "font.size=32" -e bash -c \
  "vim -u DEFAULTS -c 'nmap <cr> \"+yl:silent !sleep 0.2<cr>:q<cr>' \
                   -c 'xmap <cr> \"+y:silent !sleep 0.2<cr>:q<cr>' \
                   -c 'map q :q!<cr>' \
                   -c 'set noruler' symbols.txt +2"
