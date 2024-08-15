#!/bin/bash 
DIRECTORY="/var/log"
TARGET="/tmp/backup_files"
if [ ! -d "$DIRECTORY" ]; then  
echo "Error: Directory '$DIRECTORY' does not exist."
exit 1
fi

if [ ! -d "$TARGET" ]; then
    mkdir -p "$TARGET"
fi

BACKUP_FILE="backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz"
tar -czvf "$TARGET/$BACKUP_FILE" -C "$DIRECTORY" .
if [ $? -eq 0 ]; then
   echo "Backup completed at $(date)" >> "$TARGET/backup_log.txt"
#DELETE BACKUPS OLDER THAN 7 DAYS
find "$TARGET" -type f -name "*.tar.gz" -mtime +7 -exec rm -rf {} \;
echo "Old backups deleted at $(date)" >> "$TARGET/backup_log.txt"
else
   echo "Backup failed at $(date)" >> "$TARGET/backup_log.txt"
fi
