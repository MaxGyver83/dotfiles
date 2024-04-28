" expect bash after `command = """`
call SyntaxRange#Include('\(^ *command = \)\@<="""', '^ *"""', 'bash', 'String')

" Allow template variables in script block
syntax match shDerefSimple "{[^}]*}" nextgroup=@shNoZSList
