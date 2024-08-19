#!/bin/bash
set -x 
set -e 
set -o pipefail
CPU_THRESHOLD=90
MEMORY_THRESHOLD=80
DISK_THRESHOLD=85
PARTITION="/" 
LOG_FILE="/var/log/resource_monitor.log"
EMAIL="Tanujarora2703@gmail.com"
SUBJECT="$(date) System Resource Alert"
echo "System Monitoring Starting at $(date)"
CPU_IDLE=$(top -bn1| grep -i "Cpu(s)" | tr -s ' ' | cut -d ' ' -f8)
CURRENT_CPU_USAGE=$(echo "1000 - $CPU_IDLE" | bc )
echo "Current CPU Usage: $CURRENT_CPU_USAGE%" >> "$LOG_FILE"
if (( ${CURRENT_CPU_USAGE%.*} > CPU_THRESHOLD )); then 
	  echo "CPU usage is above threshold ($CPU_THRESHOLD%)" >> "$LOG_FILE"
    	CPU_ALERT="CPU usage is high: $CPU_USAGE%"
fi

MEMORY_TOTAL=$(free -m | awk 'NR==2{printf "%.2f\n", $2}')
MEMORY_USED=$(free -m | awk 'NR==2{printf "%.2f\n", $3}')