#!/bin/bash 
CURRENT_PORTS=$(netstat -tulpn | grep -i "LISTEN")
DATE=$(date +%Y-%m-%dT%H:%M:%S)
LOG_DIRECTORY= "/var/log/ports/status"
mkdir - p "$LOG_DIRECTORY"
LOG_FILE="$LOG_DIRECTORY/ports_status_$(date +%Y-%m-%)
echo "Current Listening Ports:"
echo "=========================="
echo "Date: $DATE"
echo "==========================="
echo "$CURRENT_PORTS" >> "$LOG_FILE"
echo "-------------------"
echo "Log saved to: $LOG_FILE"
