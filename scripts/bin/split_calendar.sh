#!/bin/sh
case "$1" in
-h|--help|'') echo "Usage: $0 <file.ics>"; exit ;;
esac

if [ ! -f "$1" ]; then
    echo "ERROR: File not found: $1"
    exit 1
fi

PREFIX='BEGIN:VCALENDAR
PRODID:-//Mozilla.org/NONSGML Mozilla Calendar V1.1//EN
CALSCALE:GREGORIAN
VERSION:2.0'

SUFFIX='END:VCALENDAR'

TEMPFILE=/tmp/temp.ics

CR="$(printf '\r')" # carriage return

line_number=0
file_count=0
warning_count=0

IFS='
' # only newline
while read -r line; do
    line_number=$((line_number + 1))
    line="${line%%$CR}"
    case "$line" in
    BEGIN:VEVENT)
        event=1
        echo "$PREFIX" > $TEMPFILE
        echo "$line" >> $TEMPFILE
        ;;
    UID:*)
        echo "$line" >> $TEMPFILE
        uid="${line#UID:}"
        echo "$uid"
        ;;
    SUMMARY:*)
        line="${line%% }" # strip trailing spaces
        echo "$line" >> $TEMPFILE
        printf "${line#SUMMARY:}\n\n"
        ;;
    END:VEVENT)
        echo "$line" >> $TEMPFILE
        if [ -n "$uid" ]; then
            echo "$SUFFIX" >> $TEMPFILE
            mv $TEMPFILE "${uid}.ics"
        else
            echo "WARNING: Skipping event (line $line_number and preceding) because UID is missing!"
            tail -n +5 $TEMPFILE
            echo ''
            warning_count=$((warning_count + 1))
        fi
        uid=
        event=0
        file_count=$((file_count + 1))
        ;;
    *)
        if [ "$event" = 1 ]; then
            printf "%s\n" "$line" >> $TEMPFILE
        fi
        ;;
    esac
done < "$1"

echo "$file_count files written."

if [ $warning_count != 0 ]; then
    printf "\n$warning_count warning(s)! Please scroll up.\n"
fi
