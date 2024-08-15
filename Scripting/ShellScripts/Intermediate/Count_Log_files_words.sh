#!/bin/bash 
LOG_DIRECTORY="/var/log/"

TOTAL_WORDS=0
LOG_FILES=$(find "$LOG_DIRECTORY" -type f -name "*.log")
for file in $LOG_FILES; do 
    if [[ -f "$file" ]]; then
    LOG_FILE_WORDS=$(wc -w < "$file")
    TOTAL_WORDS=$(($TOTAL_WORDS+ $LOG_FILE_WORDS))
    fi 
done 
echo "Total words in all log files: $TOTAL_WORDS"
