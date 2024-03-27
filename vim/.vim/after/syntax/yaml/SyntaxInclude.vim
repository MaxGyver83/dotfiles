" expect bash after p.e. `- script: |` or `- command: >-`
call SyntaxRange#Include('^ *-\? \(script\|bash\|command\|inlineScript\): \(|\|>-\)', 'condition:\|displayName:\|log_globs:\|wait:', 'bash')

" Allow template variables ...

" ... in YAML
syntax match doublebraces "\v\$\{\{.{-}\}\}" containedin=ALL
highlight doublebraces ctermfg=208 guifg=208

syntax match squarebrackets "\v\$\[.*\]" containedin=ALL
highlight squarebrackets ctermfg=blue guifg=blue

syntax match braces '\v\$\{[0-9A-Za-z_.]{-}\}' containedin=ALL
highlight braces ctermfg=green guifg=green

syntax match parens '\v\$\([0-9A-Za-z_.-]{-}\)' containedin=ALL
highlight parens ctermfg=220 guifg=220

" ... in script block
syntax match shDerefSimple "\${{[^}]*}}" nextgroup=@shNoZSList
