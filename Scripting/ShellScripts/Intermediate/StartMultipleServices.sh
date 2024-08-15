#!/bin/bash
services=(nginx docker)
for service in "${services[@]}"; do
    systemctl is-active "$service" --quiet
    service_status=$?
    if [ $service_status -eq 0 ]; then
        echo "$(date): $service is already started." >> /home/tanujgym/service.log
    else
        echo "$(date): Attempting to start the service $service." >> /home/tanujgym/service.log
        sudo systemctl start "$service"
    
        if [ $? -eq 0 ]; then
            echo "$(date): $service has been started now." >> /home/tanujgym/service.log
        else
            echo "$(date): Failed to start the service $service." >> /home/tanujgym/service.log
        fi
    fi
done
