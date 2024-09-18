#!/bin/bash
#AUTHOR: TANUJ ARORA
#DATE: 30th July 2024
#LAST UPDATE: 30th July 2024
log_file="/var/log/app.log"
while true;do 
 if grep -iq "ERROR" "$log_file"; then 
    error_date= $(date +%Y-%m-%d-%H-%M-%S)
    echo "Error detected in log file at $error_date" >> /var/log/error.log
    mail -s "CRIT!!!!:Error detected in log file" tanujarora2703@gmail.com < /var/log/error.log
    sleep 120
    echo "Last Error Occured at $error_date" >> /var/log/error.log
    echo "---------------------------------"
fi 
done 
