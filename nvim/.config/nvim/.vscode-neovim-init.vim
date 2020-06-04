set runtimepath+=~/.vim/pack/plugins/start/vim-commentary,~/.vim/pack/plugins/start/vim-surround,/home/max/.vim/pack/plugins/start/vim-sneak

set hidden           " allow leaving a buffer unsaved when switching to another one
set ignorecase       " make search case-insensitive by default (word\C → case sens.)
set smartcase        " make search case-sensitive if word contains uppercase letter
set incsearch        " search as characters are entered
set hlsearch         " highlight matches

" highlight trailing whitespaces (but do not in insert mode)
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" also highlight no-break spaces (U+00A0) and narrow no-break spaces (U+202F),
" and soft hyphen (U+00AD)
highlight NoBreakWhitespace ctermbg=blue guibg=blue
autocmd Syntax * syn match NoBreakWhitespace / \| \|­/

"---------
" mappings
"---------
let mapleader="\<Space>"   " leader is space

" insert line and return to normal mode
nnoremap <Return> o<Esc>

" yank/cut/paste to/from system clipboard
noremap <Leader>y "+y
noremap <Leader>d "+d
noremap <Leader>p "+p
noremap <Leader>P "+P

" copy complete file content to system clipboard
noremap <Leader>ca gg"+yG``

" copy relative path/full path/just filename to clipboard
noremap <Leader>cr :let @+ = expand("%")<cr>
noremap <Leader>cp :let @+ = expand("%:p")<cr>
noremap <Leader>cn :let @+ = expand("%:t")<cr>

" copy file/selection formatted as HTML for emails (no line numbers)
let g:html_number_lines = 0
let g:html_no_progress = 1
let g:html_pre_wrap = 0
nnoremap <Leader>ch :TOhtml \| call MakeHtmlReadyForEmail() \| %y+ \| bw!<cr>
xnoremap <Leader>ch :TOhtml \| call MakeHtmlReadyForEmail() \| %y+ \| bw!<cr>
nnoremap <Leader>ce :TOhtml \| call MakeHtmlReadyForEmail() \| exe 'w !xclip -sel clip -t text/html' \| bw!<cr>
xnoremap <Leader>ce :TOhtml \| call MakeHtmlReadyForEmail() \| exe 'w !xclip -sel clip -t text/html' \| bw!<cr>

" show diff between buffer and saved file
"nnoremap <Leader>i :w !diff --color :p:h -<cr>

" scroll line up with C-u
nnoremap <C-u> <C-e>

" save file (:update only writes if file was changed)
noremap <Leader>w :Write<cr>

" close buffer
noremap <Leader>b :Quit<cr>

" close window
noremap <Leader>q :Quit<cr>

" delete not into register (use dl for cutting one character into register)
nnoremap x "_x

" delete not into register with <Leader>d
nnoremap <Leader>d "_d

" select word/WORD under cursor
nnoremap <Leader>v viw
nnoremap <Leader>V viW

" replace word/selection with yanked text
nnoremap <Leader>r "_ciw<C-r>"<ESC>
xnoremap <Leader>r "_c<C-r>"<ESC>

" search selection with *
xnoremap * <ESC>/<C-r>*<cr>
" search word under cursor expanding the selection with leader *
xnoremap <Leader>* *

" move vertically up or down to next non-whitespace character
" (similar to Ctrl-Up/Down in Excel/LibreOffice)
nnoremap <silent><Leader><Up> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>
nnoremap <silent><Leader><Down> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>
nnoremap <silent><C-Up> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>
nnoremap <silent><C-Down> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>

" swap ; and , (next/previous match after t, T, f, F)
nnoremap ; ,
nnoremap , ;
xnoremap ; ,
xnoremap , ;

" Map g. as an alias for g;
nnoremap g. g;

" move vertically by visual line
" if a count is given, ignore wrapped lines
nnoremap <expr> <Down> (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> <Up> (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> <Down> (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> <Up> (v:count == 0 ? 'gk' : 'k')

" make Y yank till end of line (as proposed in `:help Y`)
map Y y$

" yank, delete or select line without line break
" (replaces plugins vim-textobj-line and vim-textobj-user)
nnoremap yal 0y$
nnoremap yil ^yg_
nnoremap dal 0d$
nnoremap dil ^dg_
nnoremap val 0v$
nnoremap vil ^vg_

" remap unused umlauts
nmap ä ;
nmap ü [
nmap ö ]
nmap ß @

"----------
" functions
"----------

function! ClearRegisters()
    let regs='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"' | let i=0 | while (i<strlen(regs)) | exec 'let @'.regs[i].'=""' | let i=i+1 | endwhile | unlet regs
endfunction
" Source: https://stackoverflow.com/questions/19430200/how-to-clear-vim-registers-effectively

function! CleanNoNameEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && (getbufline(v:val, 1, "$") == [""])')
    if !empty(buffers)
        exe 'bd '.join(buffers, ' ')
    endif
endfunction
"Source: https://www.reddit.com/r/vim/comments/1a4yf1/how_to_automatically_close_unedited_unnamed/

" delete trailing whitespaces, usage:
" :TrimWhitespace
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction
command! TrimWhitespace call TrimWhitespace()

function! MakeHtmlReadyForEmail()
    " delete javascript block
    %s/<script\_.*<\/script>//ge
    " delete CSS for body (black background)
    g/^body {/d
    " delete font-size: 1em for every tag
    g/^\* {/d
    " delete comments
    g/^<!--/d
    g/^-->/d
    " add padding and (try to) prevent wrapping long lines
    %s/^pre {/pre { padding: 0.4em; overflow-x: auto; white-space: pre;/
    " fix title (remove '.html') that will be added when inserted in Gmail
    %s/\.html<\/title>/<\/title>/g
    " make all CSS inline (do first 'pip3 install premailer --user')
    %!python3 -m premailer
    " delete unnecessary meta tags
    g/^<meta name=/d
    " save copied html in file for checking later what has been copied
    w! /tmp/email.html
endfunction

" swap ; and , (next/previous match after s, S)
nmap ; <Plug>SneakPrevious
nmap , <Plug>SneakNext
vmap ; <Plug>SneakPrevious
vmap , <Plug>SneakNext
"let g:sneak#s_next = 1
" vim-sneak case-insensitive
let g:sneak#use_ic_scs = 1
" turn off search highlight and sneak highlight
nnoremap <Leader><Space> :nohlsearch \| call sneak#cancel()<CR>
