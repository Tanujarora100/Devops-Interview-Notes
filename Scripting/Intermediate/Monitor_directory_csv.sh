#!/bin/bash

DIRECTORY="/path/to/your/directory"
LOGFILE="$PWD/dir_changes.log"
inotifywait -m "$DIRECTORY" -e create -e modify -e delete -e move |
while read path action file; do
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $action - $file in $path" >> "$LOGFILE"
done
