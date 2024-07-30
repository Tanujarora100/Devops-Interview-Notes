#!/bin/bash 
DIRECTORY="/var/log"
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi
total_words=0
echo "---------------------------$(date)"
for file in "$DIRECTORY"/*; do 
    if [ -f "$file" ]; then 
        per_file=$(wc -w < "$file")
        total_words=$((total_words + per_file))
    fi
done 
echo "Total words in all files: $total_words"