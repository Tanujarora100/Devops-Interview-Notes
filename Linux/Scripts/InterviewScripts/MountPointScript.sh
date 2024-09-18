#!/bin/bash

threshold=80
for partition in $(df -h | grep '^/dev' | awk '{print $1}'); do
    usage=$(df -h | grep "$partition" | awk '{print $5}' | sed 's/%//')
    if [ "$usage" -gt "$threshold" ]; then
        echo "Alert: $partition usage is above $threshold%."
    fi
done