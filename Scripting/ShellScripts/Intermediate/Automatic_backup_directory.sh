#!/bin/bash 
DIRECTORY="/var/log" 
BACKUP_DIR="/tmp/file_backup"
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi
inotifywait -m "$DIRECTORY" -e modify | 
while read path action file; do 
    cp "$path/$file" "$BACKUP_DIR"
    echo "Backup '$file' created at $(date)" >> "$BACKUP_DIR/backup_log
done