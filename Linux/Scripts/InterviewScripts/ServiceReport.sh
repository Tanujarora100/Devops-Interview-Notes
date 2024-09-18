#!/bin/bash #!/bin/bash 
services=(nginx docker)
for service in "${services[@]}"; do 
    echo "Checking the status of the service: $(date)" >> /home/tanujgym/service.log 
    systemctl is-active --quiet "$service" 
    if [ $? -eq 0 ]; then 
        echo "Service is already started " | mail -s "Service Status" tanujarora2703@gmail.com 
    else 
    echo "Service is not started......" >> /home/tanujgym/service.log 
    echo "Attempting to restart....." >> /home/tanujgym/service.log
    echo "------------------------------------------------"
    sudo systemctl start "$service"
    if [ $? -eq 0 ]; then 
        echo "$service has been started" | mail -s "$service restarted" tanujarora2703@gmail.com 
    else 
        echo "Failed to restart $service" | mail -s "$service restart failed" tanujarora2703@gmail.com 
    fi 
    fi 
done 