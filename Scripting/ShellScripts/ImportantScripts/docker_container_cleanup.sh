#!/bin/bash 
set -x 
set -e 
set -o pipefail 
LOG_FILE="/home/$USER/container_status.log"
if [[ -z "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
fi 
echo "Docker Cleanup Script Started at $(date)" > "$LOG_FILE"
echo "Container Status: $(date)" >> "$LOG_FILE"
docker ps >> "$LOG_FILE" 2>&1
echo "Removing exited containers" >> "$LOG_FILE"
docker container prune -f >> "$LOG_FILE" 2>&1
echo "Removing dangling images" >> "$LOG_FILE"
docker image prune -f >> "$LOG_FILE" 2>&1
echo "Removing unused volumes" >> "$LOG_FILE"
docker volume prune -f >> "$LOG_FILE" 2>&1
echo "Docker Cleanup Script Completed at $(date)" >> "$LOG_FILE"

cleanup_summary=$(cat "$LOG_FILE")
echo "$cleanup_summary" | mail -s "Docker Cleanup Completed $(date)" "tanujarora2703@gmail.com"