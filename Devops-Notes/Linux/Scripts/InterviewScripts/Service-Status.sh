#!/bin/bash
Service= "nginx"
SERVICE_LOG= "/var/log/nginx"
CURRENT_DATE= $(date +%Y-%m-%d-%H:%M:%S)
if ! systemctl is-active "$Service" --quiet; then 
    echo "Service is not active at CURRENT_DATE "  >> "$SERVICE_LOG"
else 
    echo "Service is active at $CURRENT_DATE " >> "$SERVICE_LOG" 