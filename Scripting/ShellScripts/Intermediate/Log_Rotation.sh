#!/bin/bash

LOG_DIRECTORY="/var/log"
ARCHIVE_DIRECTORY="/home/$USER/archived_logs"
LOG_FILE="/home/$USER/log_rotation.log"

if [[ ! -d "$LOG_DIRECTORY" ]]; then 
    echo "$(date): Log directory $LOG_DIRECTORY does not exist." >> "$LOG_FILE"
    exit 1
fi 
if [[ ! -d "$ARCHIVE_DIRECTORY" ]]; then 
    echo "$(date): Archive directory $ARCHIVE_DIRECTORY does not exist. Creating it." >> "$LOG_FILE"
    mkdir -p "$ARCHIVE_DIRECTORY"
fi 

BACKUP_FILE="$ARCHIVE_DIRECTORY/logs_$(date +%Y-%m-%d).tar.gz"
find "$LOG_DIRECTORY" -type f -name "*.log" -exec tar -czvf "$BACKUP_FILE" {} + >> "$LOG_FILE" 2>&1

if [[ $? -eq 0 ]]; then 
    echo "$(date): Backup succeeded and saved to $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "$(date): Backup failed." >> "$LOG_FILE"
    exit 1
fi 

find "$ARCHIVE_DIRECTORY" -type f -name "*.tar.gz" -mtime +5 -exec rm -f {} \;

if [[ $? -eq 0 ]]; then
    echo "$(date): Old backups deleted successfully." >> "$LOG_FILE"
else
    echo "$(date): Failed to delete old backups." >> "$LOG_FILE"
fi
