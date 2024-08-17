#!/bin/bash 
DIRECTORY="/var/log"
LOG_FILE="/home/$USER/log_file.log"
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: Directory '$DIRECTORY' does not exist." | tee -a "$LOG_FILE"
    exit 1
fi

EMPTY_FILES=$(find "$DIRECTORY" -type f -name "*.log")
if [[ -z "$EMPTY_FILES" ]]; then
 echo "Error: No log files found in directory $DIRECTORY" | tee -a "$LOG_FILE"
else  
 find "$DIRECTORY" -name "*.log" -type f -empty -delete 
 echo "Log files in '$DIRECTORY' that are empty have been deleted." | tee -a "$LOG_FILE"
fi 

