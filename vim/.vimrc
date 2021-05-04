set nocompatible            " be iMproved, required
set hidden                  " allow leaving a buffer unsaved when switching to another one

filetype plugin on
runtime macros/matchit.vim

syntax enable       " enable syntax highlighting

"set background=dark
" Color scheme
" (I like molokai, solarized, badwolf, afterglow, happy_hacking, minimalist)
try
    colorscheme minimalist
catch /^Vim\%((\a\+)\)\=:E185/
    " alternative if minimalist is not installed
    colorscheme torte
    highlight LineNr     ctermfg=59   ctermbg=234 cterm=NONE
    highlight CursorLine ctermfg=NONE ctermbg=239 cterm=NONE
    highlight Special    ctermfg=172              cterm=bold          guifg=Orange
endtry
highlight DiffAdd    ctermfg=10   ctermbg=24  cterm=bold gui=none guifg=bg guibg=Red
highlight DiffDelete ctermfg=167  ctermbg=bg  cterm=NONE          guifg=#D75F5F guibg=#1C1C1C
highlight DiffChange ctermfg=10   ctermbg=24  cterm=bold gui=none guifg=bg guibg=Red
highlight DiffText   ctermfg=10   ctermbg=167 cterm=bold gui=none guifg=bg guibg=Red

" Allow to use Ctrl-s and Ctrl-q as keybinds even when not started from a
" shell
if has('unix')
    silent !stty -ixon
endif

" scrolling with mouse wheel does not move the cursor
" mouse wheel doesn't scroll terminal backlog in tmux
" mouse for vim selection (=VISUAL mode)
set mouse=a

set number           " show line numbers
set showcmd          " show command in bottom bar
set ruler
set cursorline       " highlight current line
set showmatch        " highlight matching [{()}]
set wildmenu         " visual autocomplete for command menu

set tabstop=4        " number of visual spaces per TAB
set softtabstop=4    " number of spaces in tab when editing
set shiftwidth=4     " 1 tab == 4 spaces
set expandtab        " tabs are spaces
set autoindent       " indent new lines
set listchars=tab:\|_ " show tabs as |_
set list             " show non-printable chars

" Workaround for bug https://github.com/vim/vim/issues/7742
"autocmd VimEnter * if exists('#FileExplorer') | exe 'au! FileExplorer *' | endif

" file type dependent
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType groovy setlocal colorcolumn=120 shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal colorcolumn=72,80
" Autocompletion for python3 (currently replaced by jedi-vim)
" if has('python3')
    " autocmd FileType python set omnifunc=python3complete#Complete
" endif
autocmd FileType mail setlocal nojoinspaces formatoptions=watqc
autocmd BufRead,BufNewFile ~/Documents/notes/*.txt setlocal syntax=sh
autocmd BufRead,BufNewFile **/kmonad/*.kbd setlocal filetype=clojure
autocmd BufRead,BufNewFile **/dwm.c set autoindent noexpandtab tabstop=4 shiftwidth=4
autocmd BufRead,BufNewFile *.js.tid set filetype=javascript noexpandtab tabstop=4 shiftwidth=4

" recognize tmux config files
autocmd BufRead,BufNewFile *.tmux set filetype=tmux
autocmd BufRead,BufNewFile /usr/share/X11/xkb/* set syntax=javascript
autocmd BufRead,BufNewFile sxhkdrc set syntax=sh

set ignorecase       " make search case-insensitive by default (word\C → case sens.)
set smartcase        " make search case-sensitive if word contains uppercase letter
set incsearch        " search as characters are entered
set hlsearch         " highlight matches

" don't consider 007 an octal number when de-/increasing using Ctrl-x/Ctrl-a
set nrformats-=octal

" show at least three lines before/after current line
set scrolloff=3

" show as much as possible of the last line in the windows (instead of @@@)
set display+=lastline

" this seems to be missing im vim 8.2
set backspace=indent,eol,start

" set language for spell checking to German and English (activate with :set spell)
set spelllang=de,en

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

" add command to history when I do: vim -c 'RgRaw ...'
if has('nvim')
    " Does not work: E121: Undefined variable: v:argv
    " augroup CustomHistory | au!
    "     au VimEnter * call map(filter(copy(v:argv), {i, v -> i > 0 && v:argv[i - 1] == '-c'}), {_, v -> histadd('cmd', v)})
    " augroup END
elseif has("patch-8.1.2233")
    augroup CustomHistory | au!
        au VimEnter * eval v:argv
            \ ->copy()
            \ ->filter({i, v -> i > 0 && v:argv[i - 1] == '-c'})
            \ ->map({_, v -> histadd('cmd', v)})
    augroup END
endif

" don't give ins-completion-menu messages
if has("patch-7.4.314")
    set shortmess+=c
endif
" show search count, e.g. [1/5]
set shortmess-=S

set completeopt=menuone
if has("patch-7.4.775")
    set completeopt+=noselect
endif
" use new popup windows in vim 8.2
if has("patch-8.2.118")
    set completeopt+=popup
endif

" no delay after pressing Escape
set timeoutlen=1000 ttimeoutlen=10

" update GitGutter signs after 750 ms of no input (also affects swap files)
set updatetime=750

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" use a bar as cursor in insert mode, underline in replace mode
" https://stackoverflow.com/a/42118416/4121487
" Does not work in JuiceSSH (Android) (TERM=linux)
if !has('nvim') && has("patch-7.4.687") && &term != 'linux'
    let &t_SI = "\e[6 q"
    let &t_SR = "\e[4 q"
    let &t_EI = "\e[2 q"
endif

" neovim: open terminals in insert mode, activate insert on entering window
if has('nvim')
    autocmd TermOpen term://* startinsert
    autocmd BufEnter,BufNew term://* startinsert
endif

"---------
" mappings
"---------
let mapleader="\<Space>"   " leader is space

" show buffer list and select by number
nnoremap gb :ls<CR>:b<Space>

" insert line and return to normal mode
nnoremap <Return> o<Esc>

" yank/cut/paste to/from system clipboard
noremap <Leader>y "+y
noremap <Leader>d "+d
noremap <Leader>p "+p
noremap <Leader>P "+P

" copy complete file content to system clipboard
noremap <Leader>ca gg"+yG``

" copy current line/selection into tmux buffer
if exists('$TMUX')
    nnoremap <Leader>, yy \| :call system('tmux load-buffer -',@")<cr>
    xnoremap <Leader>, y \| :call system('tmux load-buffer -',@")<cr>
endif
" copy current line/selection into tmux buffer and paste into second pane
" This mapping is made for sending code lines to ipython3. Disable %autoindent first!
if exists('$TMUX')
    nnoremap <Leader><Return> yy \| :silent call system('tmux load-buffer -',@") \| :silent exe '!tmux paste -t 2' \| exe ':redraw!'<cr>
    xnoremap <Leader><Return> y \| :silent call system('tmux load-buffer -',@") \| :silent exe '!tmux paste -t 2 \; send -t 2 Enter' \| exe ':redraw!'<cr>
endif

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
nnoremap <Leader>i :w !diff --color % -<cr>

" scroll line up with C-u
nnoremap <C-u> <C-e>

" save file (:update only writes if file was changed)
noremap <C-s> :update<cr>
vnoremap <C-s> <C-c>:update<cr>
inoremap <C-s> <C-c>:update<cr>
noremap <Leader>w :update<cr>

" close buffer
noremap <Leader>b :bd<cr>

" close window
noremap <Leader>q :q<cr>
nnoremap <C-q> :q<cr>

" start recording a macro with Q instead of q (and unmap q)
nnoremap Q q
nnoremap q <Nop>

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

" overwrite with yanked text
nnoremap <Leader>R R<C-r>"<ESC>

" search selection with *
xnoremap * <ESC>/<C-r>*<cr>
" search word under cursor expanding the selection with leader *
"xnoremap <Leader>* *
" search word under cursor in all files in working directory using FZF + ripgrep
nnoremap <silent> <Leader>* :Rg <C-R><C-W><CR>

" search and replace in whole file
nnoremap <Leader>s :% s/\v//g<left><left><left>

" print value of environment variable under cursor
nnoremap <Leader>z l?\$<cr>v/\$[a-zA-Z{}_]\+/e<cr>"vy:echo <C-R>v<cr>

" send current line/selection to other vim (terminal) window
" if has('nvim')
"     " use after :vsp | term ipython3 --no-autoindent
"     nnoremap <Leader>s yy<C-w>w<C-\><C-n>pi<cr><C-\><C-n><C-w>w
"     xnoremap <Leader>s y<C-w>w<C-\><C-n>pi<cr><C-\><C-n><C-w>w
" else
"     " use after :vert term ipython3 --no-autoindent
"     nnoremap <Leader>s yy<C-w>w<C-w>"0<C-w>w
"     xnoremap <Leader>s y<C-w>w<C-w>"0<C-w>w
" endif

" move vertically up or down to next non-whitespace character
" (similar to Ctrl-Up/Down in Excel/LibreOffice)
nnoremap <silent><Leader><Up> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>
nnoremap <silent><Leader><Down> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>
nnoremap <silent><C-Up> :call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>
nnoremap <silent><C-Down> :call search('\%' . virtcol('.') . 'v\S', 'W')<CR>

" execute file in python
autocmd FileType python nnoremap <Leader>x :w !python3<cr>
" execute selection in python
autocmd FileType python xnoremap <Leader>x :w !python3<cr>

autocmd FileType groovy nnoremap <Leader>x :w \| !groovy %<cr>

" open file with xdg-open
nnoremap <Leader>o :!xdg-open % &<cr>

" toggle buffer
nnoremap <Leader>t <C-^>

" toggle window
nnoremap <Leader>k <C-w><C-w>

nnoremap <Leader>l :20Lex \| call CleanNoNameEmptyBuffers()<cr>

" surround in <kbd> tags
" xnoremap <Leader>k <Plug>VSurround<kbd>

" previous/next result (after vimgrep)
"noremap <Leader>e :cprevious<cr>
"noremap <Leader>i :cnext<cr>
" noremap <C-h> :cprevious<cr>
" noremap <C-l> :cnext<cr>

" previous/next difference in vimdiff
if &diff
    noremap <C-l> [c
    noremap <C-h> ]c
    highlight clear CursorLine
    highlight CursorLine gui=underline cterm=underline
endif

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
noremap <Leader>Y ^"+yg_

noremap <C-Left> b
noremap <C-Right> w
noremap <S-Left> B
noremap <S-Right> W

" Move lines up and down via Ctrl + j or k

" Normal mode
" nnoremap <C-j> :m .+1<CR>==
" nnoremap <C-k> :m .-2<CR>==

" Insert mode
"inoremap <C-j> <ESC>:m .+1<CR>==gi
"inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
" xnoremap <C-j> :m '>+1<CR>gv=gv
" xnoremap <C-k> :m '<-2<CR>gv=gv

" Move lines up and down via Shift + arrow keys
" (currently overwritten by terminator settings)

" Normal mode (may change indentation)
" nnoremap <S-Down> :m .+1<CR>==
" nnoremap <S-Up> :m .-2<CR>==

" better: keep indentation
nnoremap <S-Down> ddp
nnoremap <S-Up> ddkP
" This moves the current line two lines up if it is the last line.

" Insert mode
inoremap <S-Down> <ESC>:m .+1<CR>==gi
inoremap <S-Up> <ESC>:m .-2<CR>==gi

" Visual mode
xnoremap <S-Down> :m '>+1<CR>gv=gv
xnoremap <S-Up> :m '<-2<CR>gv=gv

" Sessions
" Quick write session with F2
map <F2> :mksession! ~/.vim_session<cr>
" And load session with F3
map <F3> :source ~/.vim_session<cr>

" remap unused umlauts
nmap ä ;
nmap ü [
nmap ö ]
nmap ß @

nnoremap j k
nnoremap k j
nnoremap l h
nnoremap h l
xnoremap j k
xnoremap k j
xnoremap l h
xnoremap h l

" navigate between windows (incl. terminal) with Alt+h/j/k/l
" (only valid for VOU keyboard layout)
if !has('nvim')
    execute "set <A-b>=\eb"
    execute "set <A-t>=\et"
    execute "set <A-r>=\er"
    execute "set <A-n>=\en"
    execute "set <A-v>=\ev"
    execute "set <A-.>=\e."
endif

if has("patch-8.0.0")
    if has('nvim')
        tnoremap <A-b> <C-\><C-N><C-w>h
        tnoremap <A-t> <C-\><C-N><C-w>j
        tnoremap <A-r> <C-\><C-N><C-w>k
        tnoremap <A-n> <C-\><C-N><C-w>l
    else
        tnoremap <A-b> <C-w>h
        tnoremap <A-t> <C-w>j
        tnoremap <A-r> <C-w>k
        tnoremap <A-n> <C-w>l
    endif
endif
inoremap <A-b> <C-\><C-N><C-w>h
inoremap <A-t> <C-\><C-N><C-w>j
inoremap <A-r> <C-\><C-N><C-w>k
inoremap <A-n> <C-\><C-N><C-w>l
nnoremap <A-b> <C-w>h
nnoremap <A-t> <C-w>j
nnoremap <A-r> <C-w>k
nnoremap <A-n> <C-w>l

" navigate between buffers with Alt+q/w
noremap <A-v> :bp<cr>
noremap <A-.> :bn<cr>

"--------------
" abbreviations
"--------------

" type kb>, get <kbd></kbd>
iab kb <kbd></kbd><C-o>F<<BS>
" auto complete closing HTML tag
iab </ </<C-X><C-O><Del><Del>
" inoremap ae ä
" inoremap oo ö
" inoremap uu ü
" inoremap sz ß


"----------
" macros
"----------

let @k = 'ysiw<kbd>'

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

" Switch to insert mode if file is empty
function InsertIfEmpty()
    if line('$') == 1 && col('$') == 1
        " File is empty
        startinsert
    endif
endfunction

"autocmd VimEnter * call InsertIfEmpty()

"-------------------
" related to plugins
"-------------------

" buftabline (https://github.com/ap/vim-buftabline)
let g:buftabline_indicators=1
let g:buftabline_numbers=2
nmap <Leader>1 <Plug>BufTabLine.Go(1)
nmap <Leader>2 <Plug>BufTabLine.Go(2)
nmap <Leader>3 <Plug>BufTabLine.Go(3)
nmap <Leader>4 <Plug>BufTabLine.Go(4)
nmap <Leader>5 <Plug>BufTabLine.Go(5)
nmap <Leader>6 <Plug>BufTabLine.Go(6)
nmap <Leader>7 <Plug>BufTabLine.Go(7)
nmap <Leader>8 <Plug>BufTabLine.Go(8)
nmap <Leader>9 <Plug>BufTabLine.Go(9)
nmap <Leader>0 <Plug>BufTabLine.Go(10)

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

" make vim-CtrlXA work well with vim-speeddating
nmap <Plug>SpeedDatingFallbackUp   <Plug>(CtrlXA-CtrlA)
nmap <Plug>SpeedDatingFallbackDown <Plug>(CtrlXA-CtrlX)

" use fzf (FuzzyFinder) in vim
set rtp+=~/workspace/fzf

" " autocompletion with supertab
" let g:SuperTabClosePreviewOnPopupClose = 1
" " try omnifunc first, then normal autocompletion
" autocmd FileType python
"     \ if &omnifunc != '' |
"     \   call SuperTabChain(&omnifunc, "<c-p>") |
"     \ endif

" mucomplete
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#always_use_completeopt = 1
" deactivate because of a bug in vim-fish: https://github.com/dag/vim-fish/issues/50
autocmd FileType fish let g:mucomplete#enable_auto_at_startup = 0
autocmd FileType fish let g:mucomplete#always_use_completeopt = 0

" jedi-vim
" let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "0"
" don't mess with other leader mappings:
let g:jedi#goto_command = "<leader>jd"
let g:jedi#goto_assignments_command = "<leader>jg"
let g:jedi#goto_stubs_command = "<leader>js"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>jn"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>jr"

" map Ctrl-f to :FZF
nnoremap <Leader>e :FZF<CR>
nnoremap <Leader>h :FZF ~<CR>

" find git merge conflict
nnoremap <leader>gm /\v^\<\<\<\<\<\<\< \|\=\=\=\=\=\=\=$\|\>\>\>\>\>\>\> /<cr>

" vim-fugitive (git support)
nnoremap <Leader>gs :G<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>gb :Gblame<cr>
nnoremap <Leader>gg :Ggrep --color 

" vim-fubitive (Bitbucket)
let g:fubitive_domain_pattern = 'athena\.daimler\.com/bitbucket'

" gitgutter
let g:gitgutter_sign_column_always = 1

" editorconfig: ensure that this plugin works well with fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_python_pyflakes_executable = 'pyflakes3'
let g:ale_python_pylint_executable = 'pylint3'
let g:ale_fixers = {'python': ['black']}

" TiddlyWiki
let g:tiddlywiki_no_mappings=1

" DidYouMean
" let g:dym_use_fzf = 1

" vim-lightline
set laststatus=2
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }
