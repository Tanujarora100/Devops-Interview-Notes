#!/bin/bash
read -p "Enter the directory you want to monitor: " DIRECTORY

if [ -z "$DIRECTORY" ]; then 
    echo "No directory entered."
    exit 1
fi 

if [ ! -d "$DIRECTORY" ]; then
    echo "Argument $DIRECTORY is not a valid directory."
    exit 1
fi

EMAIL="tanujarora2703@gmail.com"
THRESHOLD=60
INTERVAL=3600
echo "Monitoring changes in $DIRECTORY..."

while true; do 
    sleep "$INTERVAL"
    CURRENT_DIRECTORY_SIZE=$(du -sm "$DIRECTORY" | awk '{ print $1 }')
    if [ "$CURRENT_DIRECTORY_SIZE" -gt "$THRESHOLD" ]; then

        echo "Directory usage has exceeded the threshold ($THRESHOLD MB) in $DIRECTORY. Current size: ${CURRENT_DIRECTORY_SIZE}MB" | mail -s "Disk Usage Alert for $DIRECTORY" "$EMAIL"
    fi 
done
