#!/usr/bin/env bash
#
# delete_path.sh - readline helper: delete the current path (including spaces)
#
# A plain "bind -x" function cannot fill the readline kill ring directly.
# Therefore the function works in two steps:
#
#   1. delete_path_prepare sets READLINE_POINT (start of the region to delete)
#      and READLINE_MARK (end of the region).
#   2. The macro then calls "kill-region", so the deleted text ends up in the
#      kill ring and can be pasted again with Ctrl-Y.
#
# Example:
#   source ~/.dotfiles/scripts/bin/delete_path.sh
#   delete_path_bind '"\e\C-h"'      # Alt+Backspace
#
# Behaviour:
#   * Always the word to the *left* of the cursor is deleted (like Ctrl-W).
#     If the cursor sits between two file names, the left one is deleted.
#   * Spaces inside single/double quotes as well as escaped spaces
#     (My\ Pictures) are NOT word boundaries.
#   * If the current word is a path containing spaces, the complete word is
#     deleted (including the quotes).
#   * The space between the deleted word and the cursor is deleted as well
#     and ends up in the kill ring (like Ctrl-W). That way a path can be
#     inserted several times with Ctrl-Y and thus duplicated:
#     cp "My File"  ->  Alt+Backspace  ->  Ctrl-Y  ->  Ctrl-Y
#   * Otherwise the function behaves like a normal Ctrl-W: delete back to the
#     last space.
#

# Determines the region to delete and sets READLINE_POINT/READLINE_MARK.
delete_path_prepare() {
    local line=${READLINE_LINE}
    local point=${READLINE_POINT}
    local len=${#line}
    local i c
    local quote='' esc=0
    local in_word=0 word_start=0 word_space=0
    local tok_start=-1 tok_end=-1 tok_space=0
    local prev_start=-1 prev_end=-1 prev_space=0
    local resolved=0

    # Walk through the line character by character and find the shell words.
    # Quoting and escapes are taken into account, so that escaped or quoted
    # spaces do not count as a word boundary.
    for (( i = 0; i < len; i++ )); do
        c=${line:i:1}

        if (( esc )); then
            [[ $c == [[:space:]] ]] && word_space=1
            esc=0
            continue
        fi

        if [[ -n $quote ]]; then
            if [[ $quote == "'" ]]; then
                if [[ $c == "'" ]]; then
                    quote=''
                elif [[ $c == [[:space:]] ]]; then
                    word_space=1
                fi
            else
                if [[ $c == '\' ]]; then
                    esc=1
                elif [[ $c == '"' ]]; then
                    quote=''
                elif [[ $c == [[:space:]] ]]; then
                    word_space=1
                fi
            fi
            continue
        fi

        case $c in
            '\')
                (( in_word )) || { in_word=1; word_start=$i; word_space=0; }
                esc=1
                ;;
            "'"|'"')
                (( in_word )) || { in_word=1; word_start=$i; word_space=0; }
                quote=$c
                ;;
            [[:space:]])
                if (( in_word )); then
                    if (( point > word_start )); then
                        if (( point <= i )); then
                            # cursor is inside the word or exactly at its end
                            tok_start=$word_start
                            tok_end=$i
                            tok_space=$word_space
                            resolved=1
                            break
                        fi
                        # cursor is behind the word
                        prev_start=$word_start
                        prev_end=$i
                        prev_space=$word_space
                    else
                        # cursor is at the start of the word or in the gap:
                        # always the word to the left of the cursor is deleted
                        tok_start=$prev_start
                        tok_end=$prev_end
                        tok_space=$prev_space
                        resolved=1
                        break
                    fi
                    in_word=0
                fi
                ;;
            *)
                (( in_word )) || { in_word=1; word_start=$i; word_space=0; }
                ;;
        esac
    done

    if (( ! resolved )); then
        if (( in_word )); then
            if (( point > word_start )); then
                # last word runs to the end of the line
                tok_start=$word_start
                tok_end=$len
                tok_space=$word_space
            else
                tok_start=$prev_start
                tok_end=$prev_end
                tok_space=$prev_space
            fi
        else
            # cursor is behind the last word (e.g. trailing space)
            tok_start=$prev_start
            tok_end=$prev_end
            tok_space=$prev_space
        fi
    fi

    if (( tok_start >= 0 )) && (( tok_space )); then
        # path containing spaces: delete the complete word
        if (( point > tok_end )); then
            # cursor is behind the word: delete the word plus the spaces up to
            # the cursor (like Ctrl-W), so that the space ends up in the kill ring
            READLINE_MARK=$point
        else
            # cursor is inside the word: delete the complete word
            READLINE_MARK=$tok_end
        fi
        READLINE_POINT=$tok_start
    else
        # fallback: like Ctrl-W, i.e. delete back to the last space
        local start=$point
        while (( start > 0 )) && [[ ${line:start-1:1} == [[:space:]] ]]; do (( start-- )); done
        while (( start > 0 )) && [[ ${line:start-1:1} != [[:space:]] ]]; do (( start-- )); done
        READLINE_MARK=$point
        READLINE_POINT=$start
    fi
}

# Binds the function to a key.
#   delete_path_bind '"\C-w"'     (key sequence in readline notation)
delete_path_bind() {
    local key=${1:-'"\e\C-h"'}

    case $key in
        '"'*) ;;
        *) key="\"$key\"" ;;
    esac

    # internal helper keys that are called by the macro
    bind -x '"\C-x\C-d": delete_path_prepare'
    bind    '"\C-x\C-k": kill-region'
    # the actual key
    bind "${key}: \"\\C-x\\C-d\\C-x\\C-k\""
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    echo "Usage: Add the following lines to your .bashrc:"
    echo "source $(realpath $0)"
    echo "delete_path_bind '\"\\C-w\"'"
fi
