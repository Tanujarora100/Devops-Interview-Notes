#!/bin/bash 
services=(nginx docker ssh cron)
for service in "${services[@]}"; do 
    status=$(systemctl is-active --quiet $service; echo $?)
    if [ $status -ne 0 ]; then
    echo "Attempting to restart service..........: $(date)"
    sudo systemctl start $service  >> /home/tanujgym/service.log 
    if [ $? -eq 0 ]; then 
        echo "Service has been restarted ...:$(date +%Y-%m-%d)" >> /home/tanujgym/service.log 
        echo "Trying to enable the service on boot........ ..." >> /home/tanujgym/service.log 
        sudo systemctl enable $service >> /home/tanujgym/service.log
    else 
    echo "Service Already Started........ ..." >> /home/tanujgym/service.log 
    sudo systemctl enable $service >> /home/tanujgym/service.log 
    fi 
fi 
done 