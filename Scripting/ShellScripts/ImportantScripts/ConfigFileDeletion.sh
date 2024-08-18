#!/bin/bash
set -e
set -o pipefail
LOG_FILE="/home/ubuntu/directory_monitoring.log"
DIRECTORY="/var/log"
if [[ -z "$LOG_FILE" || -z "$DIRECTORY" ]]; then
    echo "Log file or directory is not set." >&2
    exit 1
fi
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Directory $DIRECTORY does not exist." >&2
    exit 1
fi

inotifywait -m "$DIRECTORY" -e create,delete,modify | while read path action file; do
    echo "$(date): $file was $action in $path" >> "$LOG_FILE"
    EXTENSION="${file##*.}"
    if [[ "$EXTENSION" == "conf" && "$action" == "DELETE" ]]; then
        BODY="$(date): CRITICAL! Configuration file deleted: $path$file"
        MAIL="Tanujarora2703@gmail.com"
        SUBJECT="CRITICAL: Configuration File Deletion"
        echo "$BODY" | mail -s "$SUBJECT" "$MAIL"
    fi
done
