#!/bin/bash
set -o pipefail 
set -e
DIRECTORY="/Users/tanujarora/Desktop/Projects/Devops"
THRESHOLD=80
LOG_FILE="/Users/tanujarora/Desktop/Projects/log_file.log"
if [[ ! -d "$DIRECTORY" ]]; then 
    echo "$(date): Directory is invalid" | tee -a "$LOG_FILE"
    exit 1
fi 
DISK_USAGE=$(df -h "$DIRECTORY" | tail -1 | awk '{print $5}' | tr -d '%')
if [[ "$DISK_USAGE" -gt "$THRESHOLD" ]]; then 
    echo "$(date): DISK USAGE IS OVER THRESHOLD ($DISK_USAGE%)" | tee -a "$LOG_FILE"
else 
    echo "$(date): DISK USAGE IS UNDER CONTROL ($DISK_USAGE%)" | tee -a "$LOG_FILE"
fi
