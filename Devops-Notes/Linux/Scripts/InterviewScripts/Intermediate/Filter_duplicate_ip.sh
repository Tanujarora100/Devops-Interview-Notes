#!/bin/bash
FILE_PATH="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes/Linux/Scripts/Duplicate-IP.txt"

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File not found at $FILE_PATH"
    exit 1
fi

NEW_IP=$(awk '{print $1}' "$FILE_PATH" | sort | uniq)
echo "$NEW_IP" > "$PWD/new_ip.txt"
#END OF THE SCRIPT
