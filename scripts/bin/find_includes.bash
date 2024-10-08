#!/bin/bash
if [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
    echo "Usage:
find_includes [PATH ...]

Get all non-system header files listed in C/C++ files of the current directory
and search for them in the given directories and list all matches.
"
    exit 0
fi

cwd="$(realpath "$(pwd)")"
git_root="$(git rev-parse --show-toplevel)"
if [ "$git_root" = "$cwd" ]; then
    directory_list="$(echo "$@")"
else
    directory_list="$(echo "$git_root $@")"
fi
not_found=""

search_file() {
    file="$1"
    # echo "File = $file"
    matches="$(fd --max-results=1 --full-path --case-sensitive "[/^]$file\$" $directory_list)"
    if [ "$matches" ]; then
        # first grep -v, then head -n 1?
        # echo "$matches" | head -n 1 | grep -v "$cwd"
        echo "$matches" | grep -v "$cwd"
        return 0
    fi
    not_found="${not_found}$file
"
    return 1
}

relative_paths="$(list_includes --raw)"

for file in $relative_paths ; do
    search_file "$file"
done

if [ "$not_found" ]; then
    >&2 echo "
No matches for:
$not_found"
fi
