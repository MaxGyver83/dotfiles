setl commentstring=;;\ %s

let g:slimv_leader = ','
" let g:slimv_lisp = 'ros run'
" let g:slimv_lisp = 'sbcl --noinform --no-userinit'
" let g:slimv_impl = 'sbcl'
let g:slimv_swank_cmd = '!tmux new-window -d -n REPL-SBCL "sbcl --noinform --no-userinit --load ~/.vim/pack/plugins/start/slimv/slime/start-swank.lisp"'
" let g:slimv_swank_cmd = "!ros -e '(ql:quickload :swank) (swank:create-server)' wait &"

" let g:paredit_mode = 0
let g:paredit_leader = ','
let g:lisp_rainbow = 1

" let g:swap#rules += [{
"   \   "filetype": ['lisp'],
"   \   "delimiter": [' '],
"   \   "body": '\%(\h\w*,\s*\)\+\%(\h\w*\)\?',
"   \ }]
