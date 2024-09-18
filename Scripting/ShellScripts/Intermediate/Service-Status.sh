#!/bin/bash
Service= "nginx"
SERVICE_LOG= "/var/log/nginx"
CURRENT_DATE= $(date +%Y-%m-%d-%H:%M:%S)
if ! systemctl is-active "$Service" --quiet; then 
    echo "Service is not active at $CURRENT_DATE "  >> "$SERVICE_LOG"
    systemctl restart "$Service" 
    if [ $? -eq 0 ]; then
        echo "Service restarted successfully at $CURRENT_DATE" >> "$SERVICE_LOG"
    else 
        echo "Failed to restart service at $CURRENT_DATE" >> "$SERVICE_LOG"
    fi
else 
    echo "Service is active at $CURRENT_DATE " >> "$SERVICE_LOG" 
fi 