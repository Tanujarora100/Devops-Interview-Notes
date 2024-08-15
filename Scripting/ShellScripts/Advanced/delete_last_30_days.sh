#!/bin/bash

DIRECTORY="/var/log"
LOGFILE="/home/$USER/deleted_file.log" 
touch "$LOGFILE"
deleted_files=$(find "$DIRECTORY" -type f -mtime +30 -exec basename {} \; -exec rm -rf {} \;)

if [[ -z "$deleted_files" ]]; then
    echo "No files deleted within the last 30 days."
else
    echo "The following files have been deleted and have been updated in the log file:" >> "$LOGFILE"
    echo "====================================================" >> "$LOGFILE"
    echo "$deleted_files" >> "$LOGFILE"
    echo "===================================================="
    echo "The following files have been deleted and are logged in $LOGFILE:"
    echo "$deleted_files"
fi
