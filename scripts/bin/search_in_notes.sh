#!/bin/bash
if [ "$#" -eq 0 ]; then
	echo 'Usage: search_in_notes.sh "Search string"'
	exit 0
fi
#grep --color=auto -hir -C $lines "$1" ~/Documents/notes/
#echo awk 'BEGIN{IGNORECASE=1}/'"$1"'/' RS="\n\n" ORS="\n\n" ~/Documents/notes/*.txt \| grep -zi "$1"
test -d ~/Dropbox/Max/Notizen/tiddlers && awk 'BEGIN{IGNORECASE=1}/'"$1"'/' RS="\n\n" ORS="\n\n" ~/Dropbox/Max/Notizen/tiddlers/*.tid | pygmentize -l ~/workspace/pygments-lexer-tiddler/tiddler.py:TiddlyWiki5Lexer -x -f terminal256 -O style=paraiso-dark | grep --color=auto -zi "$1"

awk 'BEGIN{IGNORECASE=1}/'"$1"'/' RS="\n\n" ORS="\n\n" $(xdg-user-dir DOCUMENTS)/notes/*.txt | pygmentize -l bash -f terminal256 -O style=monokai | grep --color=auto -zi "$1"
