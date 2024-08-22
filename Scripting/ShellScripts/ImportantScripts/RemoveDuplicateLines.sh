#!/bin/bash 
FILE_PATH="/var/log"
if [[ ! -f "$FILE_PATH" ]]; then 
    echo " Invalid File Path Provided" >> /dev/null 2>&1
    exit 1
fi
NEW_FILE="/users/$USER/withoutblanks.txt" 
> "$NEW_FILE"

sort "$FILE_PATH" | uniq > "$NEW_FILE"
