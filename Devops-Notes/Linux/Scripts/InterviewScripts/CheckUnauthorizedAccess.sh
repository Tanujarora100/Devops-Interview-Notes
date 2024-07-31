#!/bin/bash

FILE_LOCATION="/Users/tanujarora/Downloads"
FILE_NAME="tanuj.txt"
FINAL_LOCATION="$FILE_LOCATION/$FILE_NAME"

if [ ! -f "$FINAL_LOCATION" ]; then
    echo "File not found at $FINAL_LOCATION"
    exit 1
fi

LAST_MODIFIED=$(stat -c %Y "$FINAL_LOCATION")

while true; do
    sleep 120  # Wait for 120 seconds
    CURRENT_MODIFIED=$(stat -c %Y "$FINAL_LOCATION")

    if [ "$CURRENT_MODIFIED" -ne "$LAST_MODIFIED" ]; then
        echo "File $FILE_NAME has been modified!" | mail -s "File Alert" tanujarora2703@gmail.com
        LAST_MODIFIED=$CURRENT_MODIFIED
    fi
done