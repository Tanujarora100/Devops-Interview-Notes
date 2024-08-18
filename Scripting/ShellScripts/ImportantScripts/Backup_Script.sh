#!/bin/bash
# AUTHOR: TANUJ ARORA
# DATE: 17 August 2024

LOG_DIRECTORY="/var/log"
BACKUP_LOGFILE="/home/$USER/backup.log"
ARCHIVE_DIRECTORY="/home/$USER/archive"
BACKUP_FILE="$ARCHIVE_DIRECTORY/backup_$(date +'%Y%m%d').tar.gz"

touch "$BACKUP_LOGFILE"
> "$BACKUP_LOGFILE"

if [[ -z "$LOG_DIRECTORY" ]] || [[ ! -d "$LOG_DIRECTORY" ]]; then
    echo "Invalid LOG_DIRECTORY: $LOG_DIRECTORY given to backup" | tee -a "$BACKUP_LOGFILE"
    exit 1
fi

FILES_TO_BEBACKUP=$(find "$LOG_DIRECTORY" -type f -name "*.log" -mtime -7)

if [[ -z "$FILES_TO_BEBACKUP" ]]; then
    echo "No log files to be backed up within the last 7 days." | tee -a "$BACKUP_LOGFILE"
    exit 0
fi

echo "Starting log backup..." | tee -a "$BACKUP_LOGFILE"
echo "=============================" | tee -a "$BACKUP_LOGFILE"

if [[ ! -d "$ARCHIVE_DIRECTORY" ]]; then
    mkdir -p "$ARCHIVE_DIRECTORY"
fi
echo "$FILES_TO_BEBACKUP" | tee -a "$BACKUP_LOGFILE"
tar -czvf "$BACKUP_FILE" $FILES_TO_BEBACKUP | tee -a "$BACKUP_LOGFILE"
find "$LOG_DIRECTORY" -type f -name "*.log" -mtime -7 -exec rm -f {} \;
echo "OLDER FILES BACKUP COMPLETED" | tee -a "$BACKUP_LOGFILE"
# ENDOFSCRIPT
