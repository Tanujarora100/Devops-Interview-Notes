#!/bin/bash
set -e 
set -o pipefail 
read -p "Enter the source directory" SOURCE
read -p "Enter the destination directory" DEST
if [ ! -d "$DEST" ]; then 
   mkdir -p "$DEST"
fi

if [ ! -d "$SOURCE" ]; then 
    echo "Source directory not specified" 
    exit 1
fi 
TIMESTAMP=$(date "+%Y-%m-%dT%H:%M")
BACKUP_FILE= "$DEST"/backup_$TIMESTAMP.tar.gz"
tar -czvf "$BACKUP_FILE" -C "$SOURCE_DIR" .
if [[ $? -ne 0]]; then 
    echo " Backup Failed " >> /dev/null
    exit 1
else 
    echo "Backup Successful" >> /dev/null
fi
