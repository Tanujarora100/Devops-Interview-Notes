#!/bin/bash

DIRECTORY="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes/AWS"
BACKUP_DIR="/Users/tanujarora/Desktop/Projects/Devops/Scripting"
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: Source directory $DIRECTORY does not exist."
    exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "Backup directory does not exist. Creating now."
    mkdir -p "$BACKUP_DIR"
fi

seven_days_old=$(find "$DIRECTORY" -mtime +7 -type f)

if [[ -n "$seven_days_old" ]]; then
    for file in $seven_days_old; do 
        cp "$file" "$BACKUP_DIR/NEW_DIR"
        basename_file=$(basename "$file")
        echo "$basename_file $(date +%Y-%d-%m)" >> "$PWD/older_files.txt"
    done 
fi 

echo "-------------------------------------" >> "$PWD/older_files.txt"
