#!/bin/bash
DIRECTORY="/var/log"
if [ ! -d "$DIRECTORY" ]; then 
    echo "Error: Directory $DIRECTORY does not exist."
    exit 1
fi
WORD="err"
echo "Looking for files containing the word $WORD"
echo "--------------------------------------$(date)"

for file in "$DIRECTORY"/*; do 
    if [ -f "$file" ]; then
        OUTPUT=$(grep -iq -o "$WORD" "$file" | wc -w)
        if [ $OUTPUT -gt 0 ]; then
            echo "$OUTPUT"
        else 
            echo "No Occurences Found"  
        fi 
    fi
done 