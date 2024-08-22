#!/bin/bash 
FILE_PATH="/var/log"
if [[ ! -f "$FILE_PATH" ]]; then 
    echo " Invalid File Path Provided" >> /dev/null 2>&1
    exit 1
fi
NEW_FILE="/users/$USER/withoutblanks.txt" 
> "$NEW_FILE"
total_lines=$(wc -l < "$FILE_PATH")
using_awk=$(awk 'END {print NR}' "$FILE_PATH")
 