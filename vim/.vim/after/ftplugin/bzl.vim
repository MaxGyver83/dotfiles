nnoremap <buffer> <C-t> :JumpToDefinition<CR>

" Prevent this file from being sourced multiple times.
" https://stackoverflow.com/questions/22633115/why-do-i-get-e127-from-this-vimscript
if exists('*JumpToRuleDefinition')
    finish
endif

function! IsBazelPackage(directory)
    return !empty(glob(a:directory..'/BUILD.bazel')) || !empty(glob(a:directory..'/BUILD'))
endfunction

function! FindBazelPackage(directory)
    if IsBazelPackage(a:directory)
        return a:directory
    endif
    let parent_dir = fnamemodify(a:directory, ':h')
    if IsBazelPackage(parent_dir)
        return parent_dir
    endif
    let parent_dir = fnamemodify(parent_dir, ':h')
    if IsBazelPackage(parent_dir)
        return parent_dir
    endif
    return ''
endfunction

function! JumpToBazelImport()
    let line = getline('.')
    let matches = matchlist(line, 'load(\(.*\))')
    if len(matches) == 0 | return | endif
    let args = matches[1]
    let arg_list = split(args, ',')
    let target = trim(arg_list[0], '"')
    let symbols = arg_list[1:]
    " xxx = "yyy" → yyy
    call map(symbols, {_, arg -> trim(substitute(arg, '^[^"]*', '', ''), '"')})
    " echo symbols

    let oldisfname = &isfname
    let &isfname ..= ',:,@-@'
    let expr_under_cursor = expand("<cfile>")
    let &isfname = oldisfname
    echo expr_under_cursor
endfunction

function! GoToBazelFile()
    " TODO: load() → jump to function definition
    let oldisfname = &isfname
    let &isfname ..= ',:,@-@'
    let path = expand("<cfile>")
    let &isfname = oldisfname

    if match(path, '\w') == -1
        return 0
    endif

    if StartsWith(path, '@py_deps')
        let path = path[8:]
    elseif StartsWith(path, '@athena')
        let path = path[7:]
    endif

    if StartsWith(path, '//')
        let path = path[2:]
        let git_root = trim(system('git rev-parse --show-toplevel'))
        if v:shell_error > 0
            echo 'Not in a git repository: '..getcwd()
            return 0
        endif
        let path = git_root..'/'..path
    elseif StartsWith(path, ':')
        let bazel_package = FindBazelPackage(expand('%'))
        if empty(bazel_package)
            echo 'Not found: '..path
            return 0
        endif
        let path = bazel_package..'/'..path[1:]
        " let abspath = expand('%:h')..'/'..path[1:]
        " let abspath_one_up = expand('%:h:h')..'/'..path[1:]
        " if empty(glob(abspath)) && !empty(glob(abspath_one_up))
        "     let path = abspath_one_up
        " else
        "     let path = abspath
        " endif
    else
        echo 'Not found: '..path
        return 0
    endif

    let tokens = split(path, ':')

    " if len(tokens) >= 2 && EndsWith(tokens[1], '.bzl')
    if EndsWith(tokens[-1], '.bzl')
        let path = join(tokens, '/')
        if !empty(glob(path))
            silent execute 'edit' path
            return 1
        endif
    else
        let path = tokens[0]..'/BUILD.bazel'
        if empty(glob(path))
            let path = tokens[0]..'/BUILD'
        endif
        if !empty(glob(path))
            silent execute "edit" path
            if len(tokens) >= 2
                let target = tokens[1]
                if search('^'..target..'(', 'W') == 0
                    call search('name *= *"'..target..'"', 'W')
                endif
            endif
            return 1
        endif
    endif
    echo 'Not found: '..path
    return 0
endfunction


function! JumpToMacroDefinition()
    let rule = expand('<cword>')
    " TODO: Search in current file before calling `rg`? Might hide duplicate
    " definitions!?
    let cmd = 'rg --column --type bazel -- "^def '..rule..'\(" 2>/dev/null'
    let matches = system(cmd)
    if matches == ''
        return 0
    end
    let [filename, line, column] = split(matches, ':')[0:2]
    if filename ==# expand('%')
        execute 'normal '..line..'G'..column..'|'
        return 1
    else
        execute 'edit +call\ cursor('..line..','..column..') '..filename
        return 1
    endif
    return 0
endfunction
command JumpToMacroDefinition call JumpToMacroDefinition()

function! JumpToRuleDefinition()
    let rule = expand('<cword>')
    let cmd = 'rg --column --type bazel -- "^'..rule..' = rule" 2>/dev/null'
    let cmd ..= ' || rg --column --type bazel -- "^'..rule..' =" 2>/dev/null'
    let matches = system(cmd)
    if matches == ''
        return 0
    end
    let [filename, line, column] = split(matches, ':')[0:2]
    if filename ==# expand('%')
        execute 'normal '..line..'G'..column..'|'
        return 1
    else
        execute 'edit +call\ cursor('..line..','..column..') '..filename
        return 1
    endif
    return 0
endfunction
command JumpToRuleDefinition call JumpToRuleDefinition()

function! JumpToDefinition()
    call JumpToRuleDefinition() || call JumpToMacroDefinition()
endfunction
command JumpToDefinition call JumpToDefinition()
