set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

set listchars=tab:\|_
highlight WhiteSpace guibg=NONE guifg=#333333 gui=NONE
GuiTabline 0

" CTRL-SHIFT-C and CTRL-Insert are Copy
vnoremap <C-S-C> "+y
vnoremap <C-Insert> "+y

" CTRL-SHIFT-V and SHIFT-Insert are Paste
map <C-S-V> "+gP
map <S-Insert> "+gP

inoremap <silent> <S-Insert> <C-R>+
