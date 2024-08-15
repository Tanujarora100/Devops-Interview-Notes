#!/bin/bash
FILE_PATH="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes/Linux/Scripts/Duplicate-IP.txt"
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found at $FILE_PATH" >> /dev/null
    exit 1
fi
tr '[:space:]' '[\n*]'< "$FILE_PATH" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr >> "$PWD/testing.txt"
