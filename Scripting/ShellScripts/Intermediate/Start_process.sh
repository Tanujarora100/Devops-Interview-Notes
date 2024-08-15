#!/bin/bash 
read -p "Enter Process Name" PROCESS 
if [[ -z "$PROCESS" ]]; then 
echo "No process name provided."
exit 1
fi 
LOG_FILE=/home/$USER/service_status.log
if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
fi

if pgrep -x "$PROCESS" > /dev/null; then 
    echo "$(date): Process Name: $PROCESS is already running" | tee -a "$LOG_FILE"
    exit 0
else 
    echo "$(date): Process Name: $PROCESS is not running" | tee -a "$LOG_FILE" 
    systemctl start "$PROCESS" 2> /dev/null
    if [[ $? -eq 0 ]]; then 
        echo "Process has been started successfully" | tee -a "$LOG_FILE"
    else 
        echo "Failed to start the process" | tee -a "$LOG_FILE"
    fi 
fi 
