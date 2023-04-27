set nocompatible            " be iMproved, required
set hidden                  " allow leaving a buffer unsaved when switching to another one
set exrc                    " read .exrc file in working directory
set secure

filetype plugin on
runtime macros/matchit.vim

syntax enable       " enable syntax highlighting

"set background=dark
" Color scheme
" (I like molokai, solarized, badwolf, afterglow, happy_hacking, minimalist)
if &term != 'cygwin'
    try
        if empty(glob('/tmp/st-light'))
            colorscheme minimalist
            if exists('$TMUX')
                highlight Normal ctermbg=NONE
                highlight LineNr ctermbg=NONE
                highlight NonText ctermbg=NONE
            endif
            highlight CursorLineNr ctermbg=NONE ctermfg=252
        else
            colorscheme PaperColor
        endif
    catch /^Vim\%((\a\+)\)\=:E185/
        " alternative if minimalist is not installed
        colorscheme torte
        highlight LineNr     ctermfg=59   ctermbg=234 cterm=NONE
        highlight CursorLine ctermfg=NONE ctermbg=239 cterm=NONE
        highlight Special    ctermfg=172              cterm=bold          guifg=Orange
    endtry
    highlight DiffAdd    ctermfg=10   ctermbg=24   cterm=bold gui=none guifg=bg guibg=Red
    highlight DiffDelete ctermfg=167  ctermbg=NONE cterm=NONE          guifg=#D75F5F guibg=#1C1C1C
    highlight DiffChange ctermfg=10   ctermbg=24   cterm=bold gui=none guifg=bg guibg=Red
    highlight DiffText   ctermfg=10   ctermbg=167  cterm=bold gui=none guifg=bg guibg=Red
    " patches / diff files
    autocmd FileType diff syntax    match diffAddedButRemoved "^+-.*"
    syntax match diffAdded /✔/
    syntax match diffRemoved /✘/
    highlight diffAdded   ctermfg=green
    highlight diffRemoved ctermfg=red
    autocmd FileType diff highlight diffAddedButRemoved ctermfg=101   |
                        \ highlight diffLine            ctermfg=blue
endif
highlight clear SignColumn

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
autocmd FileType html,css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType groovy setlocal colorcolumn=120 shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal colorcolumn=72,80,100 | nmap gca A  # | nmap gco o# | nmap gcO O# 
autocmd FileType python syn match Function '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%(\s*(\)'
autocmd FileType c nmap gca A // | nmap gco o// | nmap gcO O// 
autocmd FileType cpp setlocal omnifunc=

" Autocompletion for python3 (currently replaced by jedi-vim)
" if has('python3')
    " autocmd FileType python set omnifunc=python3complete#Complete
" endif
autocmd FileType mail setlocal nojoinspaces formatoptions=watqc
autocmd BufRead,BufNewFile ~/Documents/notes/*.txt setlocal syntax=sh
autocmd BufRead,BufNewFile **/conanfile.txt setlocal filetype=toml
autocmd BufRead,BufNewFile **/kmonad/*.kbd setlocal filetype=clojure
autocmd BufRead,BufNewFile /tmp/*.kbd setlocal filetype=clojure
autocmd BufRead,BufNewFile **/dwm.c set autoindent noexpandtab tabstop=4 shiftwidth=4
autocmd BufRead,BufNewFile *.js.tid set filetype=javascript noexpandtab tabstop=4 shiftwidth=4
autocmd BufRead,BufNewFile *.h,*.c set filetype=c

" disable MUcomplete for fish and for git commit messages
autocmd BufEnter * if &ft ==# 'gitcommit' || &ft ==# 'fish' | MUcompleteAutoOff | else | MUcompleteAutoOn | endif

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

" enable jumping to file with 'gf' in such a line: logfile=/home/max/file.log
set isfname-==

" show at least three lines before/after current line
set scrolloff=3

" show as much as possible of the last line in the windows (instead of @@@)
set display+=lastline

" this seems to be missing im vim 8.2
set backspace=indent,eol,start

" set language for spell checking to German and English (activate with :set spell)
set spelllang=de,en

" highlight trailing whitespaces (except when typing at the end of a line)
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" also highlight no-break spaces (U+00A0) and narrow no-break spaces (U+202F),
" and soft hyphen (U+00AD)
highlight NoBreakWhitespace ctermbg=blue guibg=blue
autocmd BufWinEnter,InsertLeave * match NoBreakWhitespace / \| \|­/

augroup autocom
    autocmd!
    autocmd VimLeave * :mksession! ~/.autosession.vim
augroup END

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
if !has('nvim') && has("patch-7.4.687") && &term != 'linux' && &term != 'win32'
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

" show (FZF) buffer list
nnoremap gb :Buffers<CR>

" insert line and return to normal mode (except in quickfix window)
nnoremap <expr> <CR> &buftype ==# 'quickfix' ? "\<CR>" : 'o<Esc>'

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
nnoremap <Leader>I :DiffSaved<cr>

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

" replace word/selection with yanked text (without yanking the replaced text)
nnoremap <Leader>r "_ciw<C-r>"<ESC>
xnoremap <Leader>r "_c<C-r>"<ESC>

" overwrite with yanked text
nnoremap <Leader>R R<C-r>"<ESC>

" search working directory with ripgrep
nnoremap <Leader>/ :Rg<space>

" search selection with *
" xnoremap * <ESC>/<C-r>*<cr>
"xnoremap <Leader>* *
" search word under cursor in all files in working directory using FZF + ripgrep
nnoremap <silent> <Leader>* :RgRaw -g '!tags' -ws <C-R><C-W><CR>
" search selection in all files in working directory using FZF + ripgrep
xnoremap <silent> <Leader>* :<BS><BS><BS><BS><BS>RgRaw -g '!tags' -ws <C-R><C-W><CR>

" search and replace in whole file
nnoremap <Leader>s :% s#\v##g<left><left><left>
" search and replace selection in whole file
xnoremap <Leader>s "vy:% s#\v<C-R>v#<C-R>v#g<left><left>

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

" compile and run a rust project
autocmd FileType rust nnoremap <Leader>x :w !cargo run<cr>

autocmd FileType groovy nnoremap <Leader>x :w \| !env JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 groovy %<cr>

" repeat last command in previous tmux pane
autocmd FileType c,cpp nnoremap <Leader>x :silent call system('tmux lastp \; send up \; send enter \; lastp')<cr>

" open file with xdg-open
nnoremap <Leader>o :!xdg-open % &<cr>
" fix gx command (maybe <leader>o can be used for something else then?)
nnoremap gx :!xdg-open <cWORD> &<CR><CR>
" nmap gx :silent execute "!xdg-open " . shellescape("<cWORD>")<CR>

" toggle buffer
nnoremap <Leader>t <C-^>

" toggle window
nnoremap <Leader>k <C-w><C-w>

" nnoremap <Leader>l :20Lex \| call CleanNoNameEmptyBuffers()<cr>

" surround in <kbd> tags
" xnoremap <Leader>k <Plug>VSurround<kbd>

" previous/next result (after vimgrep)
"noremap <Leader>e :cprevious<cr>
"noremap <Leader>i :cnext<cr>
noremap <C-p> :cprevious<cr>
noremap <C-n> :cnext<cr>

" previous/next misspelled word, previous/next difference in vimdiff, previous/next error in ALE (if loaded) or previous/next hunk (gitgutter) otherwise
nmap <expr> <C-l> &spell ? '[s' : &diff ? '[c' : (exists("g:ale_enabled") && g:ale_enabled==1) ? ':ALEPrevious<CR>' : '<Plug>(GitGutterPrevHunk)'
nmap <expr> <C-h> &spell ? ']s' : &diff ? ']c' : (exists("g:ale_enabled") && g:ale_enabled==1) ? ':ALENext<CR>' : '<Plug>(GitGutterNextHunk)'
" or previous/next C function otherwise
" '?\(\(if\\|for\\|while\\|switch\\|catch\)\_s*\)\@64<!(\_[^)]*)\_[^;{}()]*\zs{<CR>'
" '/\(\(if\\|for\\|while\\|switch\\|catch\)\_s*\)\@64<!(\_[^)]*)\_[^;{}()]*\zs{<CR>'
if &diff
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

" swap C-] and C-t
nnoremap <C-]> <C-t>
nnoremap <C-t> <C-]>

" move vertically by visual line
" if a count is given, ignore wrapped lines
nnoremap <expr> <Down> (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> <Up> (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> <Down> (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> <Up> (v:count == 0 ? 'gk' : 'k')

" move by 10 lines
noremap <C-b> 10gk
noremap <C-f> 10gj

" make Y yank till end of line (as proposed in `:help Y`)
map Y y$

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)' && !has('nvim')
  " Enable modified arrow keys, see `:help xterm-modifier-keys`
  execute "silent! set <xUp>=\<Esc>[@;*A"
  execute "silent! set <xDown>=\<Esc>[@;*B"
  execute "silent! set <xRight>=\<Esc>[@;*C"
  execute "silent! set <xLeft>=\<Esc>[@;*D"
endif

" swap C-Arrow and S-Arrow because in gedit/Firefox/fish C-Arrow jumps a word (not a WORD)
noremap <C-Left> b
noremap <C-Right> w
noremap <S-Left> B
noremap <S-Right> W
inoremap <S-Left> <C-o>B
inoremap <S-Right> <C-o>W

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
map <F2> :mksession! ~/.session.vim<cr>
" And load session with F3
map <F3> :source ~/.session.vim<cr>
" Load automatically saved session with F4
map <F4> :source ~/.autosession.vim<cr>

" Markdown formatting
nnoremap <leader>m0 :s/\v^#+ *//e<CR>
nnoremap <leader>m1 :s/\v^#+ *//e<CR>0i#<space><ESC>
nnoremap <leader>m2 :s/\v^#+ *//e<CR>0i##<space><ESC>
nnoremap <leader>m3 :s/\v^#+ *//e<CR>0i###<space><ESC>
nnoremap <leader>m4 :s/\v^#+ *//e<CR>0i####<space><ESC>
nmap <leader>mi ysiW_
nmap <leader>mb ysiW*.
nmap <leader>mm ysiW`
xmap <leader>mm S`
nnoremap <leader>mM o```<ESC><up>O```
nmap <leader>ml ysiW]%a()<left>
xmap <leader>mi S_
xmap <leader>mb S*gvS*
xmap <leader>ml S]%a()<left>

" remap unused umlauts
nmap ä ;
" nmap ü [
" nmap ö ]
noremap ü 10gk
noremap ö 10gj
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

if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-b> <C-\><C-N><C-w>h
    tnoremap <A-t> <C-\><C-N><C-w>j
    tnoremap <A-r> <C-\><C-N><C-w>k
    tnoremap <A-n> <C-\><C-N><C-w>l
endif
if has("patch-8.0.0")
    tnoremap <Esc> <C-\><C-n>
    tnoremap <A-b> <C-w>h
    tnoremap <A-t> <C-w>j
    tnoremap <A-r> <C-w>k
    tnoremap <A-n> <C-w>l
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
iab pr printf("\n");
iab fpr fprintf(stderr, "\n");
" inoremap ae ä
" inoremap oo ö
" inoremap uu ü
" inoremap sz ß


"----------
" macros
"----------

let @k = 'ysiw<kbd>'

"---------------------
" functions / commands
"---------------------

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

function! GitHub()
    :execute ':!xdg-open https://github.com/' . shellescape(expand('<cWORD>'))
endfunction
command! GitHub call GitHub()

function! AddIncludeSubdirectoriesToPath(directory)
    let $include_dirs = system('fd include '.a:directory.' | tr "\n" ,')
    if stridx($include_dirs, 'fd error') < 0
        let $include_dirs = substitute($include_dirs, ',$', '', '')
        set path+=$include_dirs
    endif
endfunction
command! -nargs=1 AddIncludeSubdirsToPath call AddIncludeSubdirectoriesToPath(<f-args>)

function! AddIncludeSubdirectoriesRelativeToGitRootToPath(directory)
    let $include_dirs = system('fd include "$(git rev-parse --show-toplevel)"/'.a:directory.'  | tr "\n" ,')
    if stridx($include_dirs, 'fd error') < 0
        let $include_dirs = substitute($include_dirs, ',$', '', '')
        set path+=$include_dirs
    endif
endfunction
command! -nargs=1 AddIncludeSubdirsToPathGit call AddIncludeSubdirectoriesRelativeToGitRootToPath(<f-args>)

function! FZF_dir_files(directory, file)
    " norm "ty
    if a:directory == "GIT_ROOT" || a:directory == "GIT_PARENT"
        let l:dir = trim(system('git rev-parse --show-toplevel'))
        if v:shell_error > 0
            " fallback in case cwd is a catkin root directory
            let l:dir = trim(system('cd src && git rev-parse --show-toplevel'))
        endif
        if a:directory == "GIT_PARENT"
            let l:dir = fnamemodify(l:dir, ":h")
        endif
    else
        let l:dir = a:directory
    endif
    " escape spaces, replace '../' with space
    let l:file = substitute(a:file, ' ', '\\ ', 'g')
    let l:file = substitute(l:file, '\.\./', '\\ ', 'g')
    " replace '.' with space when followed by more than 3 characters
    let l:file = substitute(l:file, '\.\(....\)', '\\ \1', 'g')
    exec ":call fzf#vim#files('" . l:dir . "', {'options':'--query " . l:file . " --select-1'})"
endfunction

function! Sum()
    :'<,'>w !awk '{s+=$1} END {print s}'
endfunction
command! Sum :<C-U>call Sum()

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

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
command! DiffSaved call s:DiffWithSaved()

" Switch to insert mode if file is empty
function InsertIfEmpty()
    if line('$') == 1 && col('$') == 1
        " File is empty
        startinsert
    endif
endfunction

function! CompareLogs()
    " Strip timestamps of raw pipeline log
    %s/\v^2022[-:.0-9TZ]+ //g
    " Replace other timestamps
    %s/\v\d+:\d+:\d+\.\d+/xx:xx:xx.yyy/g
    " Strip color codes (use "Ctrl-v Esc" to generate "^[")
    %s/\v\[\d+m//g
    " Delete uninteresting lines
    g/^Ensuring.*rules are compiled/d
    g/^Loading rules/d

    TrimWhitespace
    " Remove duplicate empty lines
    %!cat -s
endfunction
command! CompareLogs call CompareLogs()

"autocmd VimEnter * call InsertIfEmpty()

function! LightlineCharcode() abort
  let line = getline('.')
  let col = col('.')
  return col - 1 < len(line) ? printf('C:%02x', char2nr(matchstr(line[(col - 1):], '^.'))) : 'C:  '
endfunction

command! FZFFunctionTagFile if !empty(tagfiles()) | call fzf#run({
\   'source': "cat " . tagfiles()[0] . ' | grep "' . expand('%:@') . '"' . " | grep -P '\tf\t' | sed -e '/^\\!/d;s/\t.*//' ". ' |  uniq',
\   'sink':   'tag',
\   'options':  '+m',
\   'bottom':     60,
\ }) | else | echo 'No tags' | endif

" https://github.com/godlygeek/vim-files/blob/master/plugin/vsearch.vim
" Visual mode search
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  " Use this line instead of the above to match matches spanning across lines
  "let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
  call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>

" When gf fails, try again without the first character
" because p.e. in Azure pipelines '/project/file' might be a relative path.
" If this fails, too, try opening 'file' (because the working directory might
" be '/project')
function! GoToFile()
    try
        normal! gf
    catch
        let path = expand("<cfile>")
        if path[0] == '/'
            let x = path[1:]
            echo 'Not found. Opening ' . x . ' instead.'
            if !empty(glob(x))
                silent execute "edit" x
            else
                let x = substitute(x, '.\{-}/', '', '')
                if !empty(glob(x))
                    silent execute "edit" x
                else
                    let x = '..' . path
                    if !empty(glob(x))
                        silent execute "edit" x
                    endif
                endif
            endif
        endif
    endtry
endfunction

noremap gf :call GoToFile()<CR>

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

"" swap ; and , (next/previous match after s, S)
"nmap ; <Plug>SneakPrevious
"nmap , <Plug>SneakNext
"vmap ; <Plug>SneakPrevious
"vmap , <Plug>SneakNext
""let g:sneak#s_next = 1
"let g:sneak#label = 1
"" vim-sneak case-insensitive
"let g:sneak#use_ic_scs = 1
"" turn off search highlight and sneak highlight
"nnoremap <Leader><Space> :nohlsearch \| call sneak#cancel()<CR>

" EasyMotion
let g:EasyMotion_keys = 'iterancyb.ouglhfzx,pdwmks'
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>l <Plug>(easymotion-bd-jk)
map <Leader><Leader>, <Plug>(easymotion-next)
nnoremap <Leader>n :nohlsearch<CR>

" make vim-CtrlXA work well with vim-speeddating
nmap <Plug>SpeedDatingFallbackUp   <Plug>(CtrlXA-CtrlA)
nmap <Plug>SpeedDatingFallbackDown <Plug>(CtrlXA-CtrlX)

" use fzf (FuzzyFinder) in vim
set rtp+=~/repos/fzf
nmap <Leader>hi :History<CR>

" search command history
nmap <Leader>: :History:<CR>

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

" minisnip
let g:minisnip_trigger = '<C-z>'

" jedi-vim
" let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "0"
" don't mess with other leader mappings:
let g:jedi#goto_command = "<leader>jd"
let g:jedi#goto_assignments_command = "<leader>jg"
let g:jedi#goto_stubs_command = "<leader>js"
let g:jedi#goto_definitions_command = "<leader>jD"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>jn"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>jr"

" open/search file in current/working/home/root/git_root directory with FZF
" mnemonic: e like in `:e[dit]`
nnoremap <Leader>ee :e<CR>

nnoremap <Leader>ec :FZF %:p:h<CR>
nnoremap <Leader>ew :FZF<CR>
nnoremap <Leader>eh :FZF ~<CR>
nnoremap <Leader>er :FZF /<CR>
nnoremap <Leader>eg :exec "call FZF_dir_files('GIT_ROOT', '.')"<CR>
nnoremap <Leader>eG :exec "call FZF_dir_files('GIT_PARENT', '.')"<CR>

" search selected (partial) file name in current/working/home/root/git_root directory with FZF
xnoremap <Leader>ec "ty:<C-U>exec "call FZF_dir_files('" . expand("%:p:h") . "', '<C-R>t')"<CR>
xnoremap <Leader>ew "ty:<C-U>exec "call FZF_dir_files('', '<C-R>t')"<CR>
xnoremap <Leader>eh "ty:<C-U>exec "call FZF_dir_files('~', '<C-R>t')"<CR>
xnoremap <Leader>er "ty:<C-U>exec "call FZF_dir_files('/', '<C-R>t')"<CR>
xnoremap <Leader>eg "ty:<C-U>exec "call FZF_dir_files('GIT_ROOT', '<C-R>t')"<CR>
xnoremap <Leader>eG "ty:<C-U>exec "call FZF_dir_files('GIT_PARENT', '<C-R>t')"<CR>

" search file name under cursor in current/working/home/root/git_root directory with FZF
nnoremap <Leader>fc :exec "call FZF_dir_files('" . expand("%:p:h") . "', '" . expand('<cfile>') . "')"<CR>
nnoremap <Leader>fw :exec "call FZF_dir_files('', '" . expand('<cfile>') . "')"<CR>
nnoremap <Leader>fh :exec "call FZF_dir_files('~', '" . expand('<cfile>') . "')"<CR>
nnoremap <Leader>fr :exec "call FZF_dir_files('/', '" . expand('<cfile>') . "')"<CR>
nnoremap <Leader>fg :exec "call FZF_dir_files('GIT_ROOT', '" . expand('<cfile>') . "')"<CR>
nnoremap <Leader>fG :exec "call FZF_dir_files('GIT_PARENT', '" . expand('<cfile>') . "')"<CR>

nnoremap <Leader>ef :FZFFunctionTagFile<CR>
nnoremap <Leader>eb :Buffers<CR>
nnoremap <Leader>el :BLines<CR>
" o like in `:oldfiles`
nnoremap <Leader>eo :History<CR>
nnoremap <Leader>es :RgRaw -g '!tags' -s ''<left>

" toggle between .c and .h files
nnoremap <expr> <Leader>et expand('%:e') == 'h' ? ':e %:r.c<CR>' : expand('%:e') == 'c' ? ':e %:r.h<CR>' : expand('%:e') == 'hpp' ? ':e **/%:t:r.cpp<CR>' : expand('%:e') == 'cpp' ? ':e **/%:t:r.hpp<CR>' :':echo "Not a c[pp] or h[pp] file."<CR>'


" jump to the next function
nnoremap <silent> <Leader>ff :call
  \ search('\(\(if\\|for\\|while\\|switch\\|catch\)\_s*\)\@64<!(\_[^)]*)\_[^;{}()]*\zs{', "w")<CR>zt
autocmd BufRead,BufNewFile *.py nnoremap <silent> <Leader>ff :call search('^def ', "w")<CR>zt

" find git merge conflict
nnoremap <Leader>gm /\v^\<\<\<\<\<\<\< \|\=\=\=\=\=\=\=$\|\>\>\>\>\>\>\> /<cr>

" vim-fugitive (git support)
nnoremap <Leader>gg :G<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>gb :Git blame<cr>
nnoremap <Leader>go :GBrowse<cr>
xnoremap <Leader>go :'<,'>GBrowse<cr>
nnoremap <Leader>gpl :Git pull<cr>
nnoremap <Leader>gps :Git push<cr>

" ale
nnoremap <Leader>ae :pa ale \| ALEEnable \| ALELint<cr>
nnoremap <Leader>at :ALEToggle<cr>
nnoremap <Leader>al :ALELint<cr>
nnoremap <Leader>af :ALEFix<cr>
nnoremap <Leader>ad :ALEDetail<cr>
nnoremap <Leader>ai :ALEInfo<cr>
nnoremap <Leader>ag :ALEGoToDefinition<cr>
nnoremap <Leader>ar :ALEFindReferences<cr>
nnoremap <Leader>ah :ALEHover<cr>

" gitgutter
let g:gitgutter_sign_column_always = 1

" editorconfig: ensure that this plugin works well with fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" any-jump
let g:any_jump_disable_default_keybindings = 1
" Jump to definition under cursor
nnoremap <leader>jj :AnyJump<CR>
" Visual mode: jump to selected text in visual mode
xnoremap <leader>jj :AnyJumpVisual<CR>

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_python_pyflakes_executable = 'pyflakes3'
let g:ale_python_pylint_executable = 'pylint3'
let g:ale_linters = {
    \ 'python': ['pycodestyle', 'pylint3', 'pylsp'],
    \ 'c': ['cc', 'clangtidy', 'clangd'],
    \ 'cpp': ['clangtidy', 'cppcheck', 'cpplint', 'clangd'],
    \ }
let g:ale_fixers = {
    \ 'python': ['black', 'isort'],
    \ 'c': ['astyle'],
    \ 'cpp': ['clangtidy', 'clang-format'],
    \ }
let g:ale_c_clangtidy_options = '-std=c99 -pedantic'
let g:ale_cpp_cpplint_options = '--filter=-legal/copyright,-whitespace/line_length,-whitespace/blank_line'
" ale look
let g:ale_sign_warning = ' !'
let g:ale_sign_error = ' X'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_virtualtext_prefix = '◼ %type%: '
highlight ALEWarningSign  ctermbg=215 ctermfg=black cterm=NONE
highlight ALEErrorSign    ctermbg=red ctermfg=NONE  cterm=bold
highlight ALEWarning      ctermbg=NONE ctermfg=red  cterm=undercurl
highlight ALEError        ctermbg=NONE ctermfg=red  cterm=undercurl
highlight ALEVirtualTextWarning ctermfg=215
highlight ALEVirtualTextError   ctermfg=red

function! LinterStatus() abort
    try
        let l:checking = ale#engine#IsCheckingBuffer(bufnr(''))
        let l:counts = ale#statusline#Count(bufnr(''))
    catch
        return 'No ALE'
    endtry

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    if l:checking == 0 && l:counts.total == 0
        return 'OK'
    endif

    let l:status = (l:checking == 1) ? 'checking' : ''
    if all_errors > 0
        let l:status = printf('%s %dE', l:status, all_errors)
    endif
    if all_non_errors > 0
        return printf('%s %dW', l:status, all_non_errors)
    endif
    return l:status
endfunction

" TiddlyWiki
let g:tiddlywiki_no_mappings=1

" DidYouMean
" let g:dym_use_fzf = 1

" vim-wordmotion
let g:wordmotion_extra = ['^#define\>', '^#ifdef\>']

" vim-lightline
set laststatus=2
set noshowmode
let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
    \   'right': [ [ 'lineinfo' ],
    \              [ 'percent' ],
    \              [ 'errorcount', 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'component_function': {
    \   'charcode': 'LightlineCharcode',
    \   'errorcount': 'LinterStatus'
    \ }
    \ }
" uncomment for showing the current character's hex code
"let g:lightline.active.right = [ [ 'lineinfo' ], [ 'percent', 'charcode' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]

" vim-highlightedyank
set clipboard-=autoselect
let g:highlightedyank_highlight_duration = 500
highlight HighlightedyankRegion ctermbg=229 ctermfg=none cterm=none

" vim-gutentags
let g:gutentags_ctags_exclude = ['virtual_envs', '.ccls-cache']
let g:gutentags_exclude_project_root = ['/usr/local', '/home/max/.password-store']
let g:gutentags_project_root = ['.gutentags']
set tags+=tags-external

" tagbar
nmap <F8> :TagbarToggle f<CR>

" quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" vim-oscyank
if $SSH_CLIENT != "" || $SSH_TTY != "" || $IN_DOCKER != ""
  " let g:oscyank_term = 'default'
  vnoremap <leader>y <Plug>OSCYankVisual
  nmap <leader>y <Plug>OSCYankOperator
endif

" termdebug
packadd termdebug
let g:termdebug_wide=1
noremap <silent> <leader>gt :Termdebug<cr>

" try loading machine-specific settings
try
  source ~/.vimrc_local
catch
  " No such file? No problem; just ignore it.
endtry
