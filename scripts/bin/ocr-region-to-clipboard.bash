#!/bin/bash
# Dependencies: tesseract-ocr imagemagick scrot xsel

# Let user select a region on the screen and recognize letters
# and copy them into the clipboard.

# select tesseract_lang in eng rus equ ;do break;done
# quick language menu, add more if you need other languages.

# https://itectec.com/ubuntu/ubuntu-how-can-instantaneously-extract-text-from-a-screen-area-using-ocr-tools/

SCR_IMG=`mktemp`
trap "rm $SCR_IMG*" EXIT

scrot -s $SCR_IMG.png -q 100
# increase image quality with option -q from default 75 to 100

mogrify -modulate 100,0 -resize 400% $SCR_IMG.png
# should increase detection rate

tesseract $SCR_IMG.png $SCR_IMG &> /dev/null
cat $SCR_IMG.txt | sed '/^\s*$/d' | xsel -bi
