#!/bin/bash 
DIRECTORY="/var/log"
COPY_DIRECTORY="/tmp/logs_backup"
if [[ ! -d "$DIRECTORY" ]]; then 
    echo "Directory does not exist" >> /dev/null
    exit 1
fi 
OLD_FILES=$(find "$DIRECTORY" -type f -name "*.log" -size +1M)
mkdir -p "COPY_DIRECTORY"
if [[ -n "$OLD_FILES" ]]; then
    for file in "$OLD_FILES"; do
     mv "$file" "$COPY_DIRECTORY" 
     echo "Moved $(basename "$file")" >> "$PWD/log_rotation.log"
     rm "$file"
done 

tar -czvf "logs_backup_$(date +%Y-%m-%d)" -C "$COPY_DIRECTORY"
rm -rf "$COPY_DIRECTORY"
echo "COMPRESSED THE LOGS OLDER THAN 7 DAYS $(date +%Y-%m-%d)" >> "$PWD/log_rotation.log" 
else 
echo "No log files found older than 7 days" >> "$PWD/log_rotation.
fi 