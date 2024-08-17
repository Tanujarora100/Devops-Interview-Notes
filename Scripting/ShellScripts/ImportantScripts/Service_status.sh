#!/bin/bash
services=(nginx docker ssh)
LOG_FILE="/home/$USER/service_status.log"
for service in "${services[@]}"; do 
  service_status=$(systemctl is-active "$service")
	if [[ "$service_status" -eq "active" ]]; then
		echo " $(date) $service is already running " >> "$LOG_FILE"
	else 
		echo "$(date) $service is not running " >> "$LOG_FILE"
		echo "Trying to restart $service ............" >> "$LOG_FILE"
		echo "==================================" >> "$LOG_FILE"
		sudo systemctl start "$service"
		if [[ $? -ne 0 ]]; then 
			SUBJECT="CRIT!!!! UNABLE TO START $service"
			BODY="CRITICAL!!! PLEASE CHECK $service, Script is unable to start the $service, Log File Path: $LOG_FILE"
			EMAIL="Tanujarora2703@gmail.com"
			echo "$BODY" | mail -s "$SUBJECT" "$EMAIL"
		fi 
		echo "$(date) $service restart successfully " >> "$LOG_FILE"
	fi 
done 

