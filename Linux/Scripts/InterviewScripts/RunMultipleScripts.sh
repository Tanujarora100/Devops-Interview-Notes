#!/bin/bash 
services=(nginx ssh docker)
for service in ${services[@]}; do 
    if systemctl is-active --quiet "$service" ; then 
        echo "service already running" >>/dev/null
    else 
        echo "starting $service, attempting to restart it" >>/dev/null
        sudo systemctl start "$service"
        if systemctl is-active --quiet "$service" ; then
            echo "service started successfully" >>/dev/null
        else
            echo "Failed to start $service"
        fi 
    fi 
done 