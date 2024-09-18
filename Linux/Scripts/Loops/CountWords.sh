#!/bin/bash
DIRECTORY="/var/log"
if [ ! -d "$DIRECTORY" ]; then 
    echo "DIRECTORY NOT FOUND" >> /dev/null
    exit 1
fi

TOTAL_WORDS=0
for file in "$DIRECTORY"/*; do 
    if [ -f "$file" ]; then
        CURRENT_WORDS=$(wc -w < "$file") 
        TOTAL_WORDS=$((TOTAL_WORDS + CURRENT_WORDS))  
    fi
done

if [ "$TOTAL_WORDS" -eq 0 ]; then
    echo "No words found in any log files."
else
    echo "Total words in all log files: $TOTAL_WORDS"
fi