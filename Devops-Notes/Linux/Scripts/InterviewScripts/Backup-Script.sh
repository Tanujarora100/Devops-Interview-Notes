#!/bin/bash
BACKUP_DIRECTORY="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes/Backups"
CURRENT_DIRECTORY="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes/Linux/Scripts"
CURRENT_DATE= $( date +%Y-%m-%d_%H:%M:%S )
# Check if backup directory exists, create it if not
mkdir -p "$CURRENT_DIRECTORY/$CURRENT_DATE"
cp -r "$CURRENT_DIRECTORY" "$CURRENT_DIRECTORY/$CURRENT_DATE"
if [ $? -eq 0 ]; then 
    echo "Backup Successfull"
else 
    echo "Backup Failed"
fi