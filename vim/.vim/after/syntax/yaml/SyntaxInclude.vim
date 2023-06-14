call SyntaxRange#Include('^ *-\? \(script\|bash\): |', 'condition:\|displayName:\|log_globs:', 'bash')

" Allow template variables ...

" ... in YAML
syntax match doublebraces "\v\$\{\{.{-}\}\}" containedin=ALL
highlight doublebraces ctermfg=blue guifg=blue

syntax match squarebrackets "\v\$\[.*\]" containedin=ALL
highlight squarebrackets ctermfg=blue guifg=blue

syntax match braces "\v\$\{[0-9A-Za-z_.]{-}\}" containedin=ALL
highlight braces ctermfg=green guifg=green

syntax match parens "\v\$\([0-9A-Za-z_.]{-}\)" containedin=ALL
highlight parens ctermfg=green guifg=green

" ... in script block
syntax match shDerefSimple "\${{.*}}" nextgroup=@shNoZSList
