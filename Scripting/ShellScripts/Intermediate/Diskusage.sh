#!/bin/bash 
THRESHOLD=40
CURRENT_USAGE=$(df -h "$PWD" | awk '{print $5}'| tr -d '%' | tail -n 1)
if [[ $CURRENT_USAGE -gt "$THRESHOLD" ]]; then
    echo "Disk usage is above $THRESHOLD%!" >> "$PWD/diskusage.txt"
    echo "CRIT!!!! DISK USAGE IS ABOVE THRESHOLD" | mail -s "DISK USAGE IS ABOVE THRESHOLD" tanujarora2703@gmail.com >> "$PWD/diskusage.txt"
fi 
