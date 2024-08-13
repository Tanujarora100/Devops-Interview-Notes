#!/bin/bash 
FILE_PATH="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes/Linux/Scripts/Duplicate-IP.txt"
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found at $FILE_PATH" >> /dev/null
    exit 1
fi
TOTAL_LINES=$( wc -l < "$FILE_PATH") 
TOTAL_WORDS=$( wc -w < "$FILE_PATH")
TOTAL_CHARACTERS=$( wc -c < "$FILE_PATH")

echo "Total lines: $TOTAL_LINES" >>"$PWD/test.txt"
echo "Total words: $TOTAL_WORDS" >>"$PWD/test.txt"
echo "Total characters: $TOTAL_CHARACTERS" >>"$PWD/test.txt"
