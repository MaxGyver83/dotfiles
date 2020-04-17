function unicode --description 'Return Unicode code point for every given symbol'
    set char_count (string length -- "$argv")
    for char in (string split '' -- "$argv")
        # if $argv is more than a single char, print it before its Unicode code point
        if test $char_count -gt 1
            echo -n $char': '
        end
        echo -n $char | iconv -f utf8 -t utf32be | xxd -p | sed -r 's/^0+/0x/' | xargs printf 'U+%04X\n'
    end
end
