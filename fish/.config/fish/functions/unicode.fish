function unicode --description 'Return Unicode code point for a symbol'
    echo -n "$argv" | iconv -f utf8 -t utf32be | xxd -p | sed -r 's/^0+/0x/' | xargs printf 'U+%04X\n'
end
