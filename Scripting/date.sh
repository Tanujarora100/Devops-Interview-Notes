#!/bin/bash 
LOG_FILE="$PWD/date.txt"
touch "$LOG_FILE"

echo $(date) >> "$LOG_FILE"
echo $(date +%Y-%m-%d) >> "$LOG_FILE"
# echo $(date +%Y-%m-%d) >> "$LOG_FILE"

