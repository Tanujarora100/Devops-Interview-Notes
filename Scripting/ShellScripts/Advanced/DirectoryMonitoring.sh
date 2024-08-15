#!/bin/bash
DIRECTORY="/var/log"
LOGFILE="/home/$USER/new_file.log" 
if [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory $DIRECTORY does not exist."
  exit 1
fi

if [ ! -f "$LOGFILE" ] || [ ! -w "$LOGFILE" ]; then
  echo "Error: Log file $LOGFILE does not exist or is not writable."
  touch "$LOGFILE"
  if [[ $? -ne 0]]; then 
   echo "Error: Failed to create log file $LOGFILE."
   exit 1
  fi 
echo "Monitoring $DIRECTORY for new files..."
fi
inotifywait -m $DIRECTORY -e create | while read path action; do 
  echo "$(date) New file created in $DIRECTORY: $path" >> "$LOGFILE"
done
