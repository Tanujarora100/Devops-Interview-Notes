#!/bin/bash

ARCHIVE_DIRECTORY="/home/$USER/archive_logs"
MONITORING_DIRECTORY="/var/log"
LOG_FILE="/home/$USER/log_monitor.log"

if [[ ! -d "$ARCHIVE_DIRECTORY" ]]; then
    mkdir -p "$ARCHIVE_DIRECTORY"
fi
inotifywait -m -e create "$MONITORING_DIRECTORY" | while read path action file;
do
    if [[ "$file" == *.log ]]; then
        FILENAME=$(basename "$file")
        ARCHIVE_PATH="$ARCHIVE_DIRECTORY/$FILENAME"
        mv "$file" "$ARCHIVE_PATH"
        if [[ $? -eq 0 ]]; then
            echo "$(date): Log file $FILENAME moved to the archive directory." | tee -a "$LOG_FILE"
        else
            echo "$(date): Error: Failed to move log file $FILENAME to archive directory." | tee -a "$LOG_FILE"
        fi
    fi
done
