set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

set listchars=tab:\|_
highlight Whitespace ctermfg=236 ctermbg=NONE cterm=NONE guifg=#222222 guibg=NONE gui=NONE
