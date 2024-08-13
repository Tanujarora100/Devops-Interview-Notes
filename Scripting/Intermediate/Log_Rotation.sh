#!/bin/bash 
DIRECTORY="/var/log"
TARGET_DIR="/tmp/archive_logs"

if [[ ! -d "$DIRECTORY" ]]; then 
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi
mkdir -p "$TARGET_DIR"

OLD_LOGS=$(find "$DIRECTORY" -type f -name "*.log" -mtime +7 -exec gzip {}\; -exec mv {}.gz "$TARGET_DIR")
echo "Logs are moved to the $TARGET_DIR at: $(date)" >> "$PWD/test.log"
echo "-----------------------------------" >> "$PWD/test.log"
#DELETE THE OLDER LOGS THAN 30 DAYS 
find "$TARGET_DIR" -type f -name "*.gz" -mtime +30 -exec rm -rf {} \;
echo "Old Archived Logs are deleted $(date)" >> "$PWD/test.log"
