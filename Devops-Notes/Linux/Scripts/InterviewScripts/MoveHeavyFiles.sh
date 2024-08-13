#!/bin/bash 
ARCHIVED_DIRECTORY="/home/tanujgym/backups/"
$RMAN_BACKUP_DIRECTORY="/home/tanujgym/rman_backups"
mkdir -p "$ARCHIVED_DIRECTORY"
mkdir -p "$RMAN_BACKUP_DIRECTORY"
DIRECTORY="/var/log"

#MOVING THE SMALLER FILES TO AN ARCHIVE DIRECTORY 
find "$DIRECTORY" -type f -size +100M -size -200M -exec gzip {} \; mv -exec {}.gz  "$ARCHIVED_DIRECTORY" \; 

#MOVING THE RMAN BACKUPS
find "$DIRECTORY" -type f -name "*.bak" -size +200M -size -500M -exec gzip {} \; -exec mv {}.gz  "$RMAN_BACKUP_DIRECTORY" \;  
echo "Script has been executed at $(date)"
#END OF THE SCRIPT