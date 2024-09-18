#!/bin/bash 
DIRECTORY="/var/log"

if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist"
    exit 1
fi 
total_lines=0 
for file in "$DIRECTORY"/*; do 
    if [ -f "$file" ]; then
        per_file=$(wc -l < "$file")
        total_lines=$((total_lines + per_file))
    fi 
done 

echo "Total lines in all log files: $total_lines"