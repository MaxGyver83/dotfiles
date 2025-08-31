" see https://github.com/lifepillar/vim-mucomplete/issues/212
let g:conjure#completion#omnifunc = 'syntaxcomplete#Complete'

let g:rainbow#blacklist = [142, 223]
RainbowParentheses

" Don't map s for paredit
function PareditMapFunction()
    call PareditMapKeys()
    unmap <buffer> s
endfunction
let g:paredit_map_func = 'PareditMapFunction'
