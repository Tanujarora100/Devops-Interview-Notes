#!/bin/bash 
set -e 
set -x 
FILE_PATH="/var/log/system.log"
if [[ ! -f "$FILE_PATH" ]]; then 
    echo " Invalid File Path Provided" >> /dev/null 2>&1
    exit 1
fi
NEW_FILE="$PWD/withoutblanks.txt" 
> "$NEW_FILE"
awk 'NF' "$FILE_PATH" >> "$NEW_FILE"
echo "File processed successfully. New file created at $NEW_FILE"

