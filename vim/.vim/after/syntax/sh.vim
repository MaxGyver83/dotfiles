" Recognize indented here-doc delimiters.
" This is necessary for here-docs in bash scripts embedded in YAML (Azure
" DevOps) files with syntax highlighting via the vim-SyntaxRange plugin.
syn region shHereDoc matchgroup=shHereDoc01 start="<<\s*\z([^< \t|>]\+\)"
            \ matchgroup=shHereDoc01 end="^ *\z1$"	contains=@shDblQuoteList
syn region shHereDoc matchgroup=shHereDoc03 start="<<\s*\\\z([^ \t|>]\+\)"
            \ matchgroup=shHereDoc03 end="^ *\z1$"
syn region shHereDoc matchgroup=shHereDoc05 start="<<\s*'\z([^']\+\)'"
            \ matchgroup=shHereDoc05 end="^ *\z1$"
syn region shHereDoc matchgroup=shHereDoc07 start="<<\s*\"\z([^"]\+\)\""
            \ matchgroup=shHereDoc07 end="^ *\z1$"
syn region shHereDoc matchgroup=shHereDoc09 start="<<\s*\\\_$\_s*\z([^ \t|>]\+\)"
            \ matchgroup=shHereDoc09 end="^ *\z1$"	contains=@shDblQuoteList
syn region shHereDoc matchgroup=shHereDoc11 start="<<\s*\\\_$\_s*\\\z([^ \t|>]\+\)"
            \ matchgroup=shHereDoc11 end="^ *\z1$"
syn region shHereDoc matchgroup=shHereDoc13 start="<<\s*\\\_$\_s*'\z([^']\+\)'"
            \ matchgroup=shHereDoc13 end="^ *\z1$"
syn region shHereDoc matchgroup=shHereDoc15 start="<<\s*\\\_$\_s*\"\z([^"]\+\)\""
            \ matchgroup=shHereDoc15 end="^ *\z1$"
