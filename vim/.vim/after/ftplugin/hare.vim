nnoremap <leader>ma :make<CR>

nnoremap <leader>,pp :call InsertPrintStatement('below', 'print', 0)<CR>
nnoremap <leader>,Pp :call InsertPrintStatement('above', 'print', 0)<CR>
nnoremap <leader>,pl :call InsertPrintStatement('below', 'print', 1)<CR>
nnoremap <leader>,Pl :call InsertPrintStatement('above', 'print', 1)<CR>
nnoremap <leader>,ee :call InsertPrintStatement('below', 'error', 0)<CR>
nnoremap <leader>,Ee :call InsertPrintStatement('above', 'error', 0)<CR>
nnoremap <leader>,el :call InsertPrintStatement('below', 'error', 1)<CR>
nnoremap <leader>,El :call InsertPrintStatement('above', 'error', 1)<CR>

vnoremap <leader>,pp <cmd>call InsertPrintStatement('below', 'print', 0)<CR>
vnoremap <leader>,Pp <cmd>call InsertPrintStatement('above', 'print', 0)<CR>
vnoremap <leader>,pl <cmd>call InsertPrintStatement('below', 'print', 1)<CR>
vnoremap <leader>,Pl <cmd>call InsertPrintStatement('above', 'print', 1)<CR>
vnoremap <leader>,ee <cmd>call InsertPrintStatement('below', 'error', 0)<CR>
vnoremap <leader>,Ee <cmd>call InsertPrintStatement('above', 'error', 0)<CR>
vnoremap <leader>,el <cmd>call InsertPrintStatement('below', 'error', 1)<CR>
vnoremap <leader>,El <cmd>call InsertPrintStatement('above', 'error', 1)<CR>

function! InsertPrintStatement(position, type, printlength)
  if mode() ==# 'v'
    let var = getregion(getpos('v'), getpos('.'), #{ type: mode() })[0]
  else
    let var = s:GetIdentifierUnderCursor()
  endif
  let cmd = (a:position ==# 'above') ? 'O' : 'o'
  if a:printlength == 1
    let var = 'len(' .. var .. ')'
  endif
  let fullcmd = 'normal '
  if mode() ==# 'v'
    let fullcmd ..= "\<esc>"
  endif
  exe fullcmd .. $"{cmd}fmt::{a:type}fln(\"{var} = '{{}}'\", {var})!;"
  call UseFmt()
endfunction

function! s:GetIdentifierUnderCursor()
  let oldiskeyword = &iskeyword
  let &iskeyword = '@,48-57,_,192-255,:'
  let str = expand("<cword>")
  if match(str, '\w') == -1
    return []
  endif
  let &iskeyword = oldiskeyword
  " remove single trailing colon (as in 'WORD_BITSZ:')
  if len(str) >= 2 && str[-1:] == ':' && str[-2:-2] != ':'
    let str = str[:-2]
  endif
  return str
endfunction

function! UseFmt()
  if search('^use fmt;', 'n') == 0
    normal m`
    call cursor(1, 1)
    let linenumber = search('^use', 'cW')
    normal Ouse fmt;
    normal ``
  endif
endfunction

" vim-CtrlXA
let g:CtrlXA_Toggles = [
    \ ['const', 'let'],
    \ ] + g:CtrlXA_Toggles
