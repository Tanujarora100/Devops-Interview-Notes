#!/bin/bash
DIRECTORY="/var/log"
if [[ ! -d "$DIRECTORY" ]]; then 
    echo "Directory does not exist" >> "$PWD/error_counts.txt"
    exit 1
fi 
TEXT_FILES=$(find "$DIRECTORY" -type f -name "*.log")
for file in $TEXT_FILES; do 
    error_counts=$(grep -i "ERROR" "$file" | wc -l)
    echo "File: $(basename "$file"), Error Count: $error_counts" >> "$PWD/error_counts.txt"
done 

echo "Error Counts Report Generated Successfully"
