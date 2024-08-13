#!/bin/bash 
DIRECTORY="/var/log"
LOG_PATH="$PWD/test.log"

if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi

inotifywait -m "$DIRECTORY" -e create -e modify -e delete | 
while read path action file; do 
echo "$(date +%Y-%m-%d): $action $file in $DIRECTORY" >> "$LOG_PATH"
done 
