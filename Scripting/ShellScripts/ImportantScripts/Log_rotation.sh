#!/bin/bash

# Configuration
LOG_DIR="/path/to/logs"        
ARCHIVE_DIR="$LOG_DIR/archive" 
RETAIN_DAYS=7                  

mkdir -p "$ARCHIVE_DIR"
CURRENT_DATE=$(date +"%Y-%m-%d")

for LOG_FILE in "$LOG_DIR"/*.log; do
    if [ -f "$LOG_FILE" ]; then
        BASE_NAME=$(basename "$LOG_FILE")
        mv "$LOG_FILE" "$ARCHIVE_DIR/$BASE_NAME.$CURRENT_DATE"
        gzip "$ARCHIVE_DIR/$BASE_NAME.$CURRENT_DATE"
        touch "$LOG_FILE"
        chmod 644 "$LOG_FILE"
        echo "Log rotation completed for $BASE_NAME. Archived as $BASE_NAME.$CURRENT_DATE.gz"
    else
        echo "No log files found in $LOG_DIR"
    fi
done
find "$ARCHIVE_DIR" -name "*.log.*.gz" -type f -mtime +$RETAIN_DAYS -exec rm {} \;

echo "Old log files older than $RETAIN_DAYS days have been deleted."
