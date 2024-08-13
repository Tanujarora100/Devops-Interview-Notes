#!/bin/bash
FILE_PATH="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes/Linux/Scripts/Duplicate-IP.txt"

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found at $FILE_PATH"
    exit 1
fi

awk '{print $1}' "$FILE_PATH" | sort | uniq -c | sort -nr > "$PWD/ip_count.txt"
echo "IP counts have been saved to ip_count.txt"
