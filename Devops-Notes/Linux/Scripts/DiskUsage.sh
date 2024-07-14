#!/bin/bash
THRESHOLD=80
CURRENT_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

if (( CURRENT_USAGE > THRESHOLD )); then
    echo "Disk usage is above ${THRESHOLD}%. Sending email notification."
    SUBJECT="Disk Usage Alert"
    MESSAGE="Disk usage on $(hostname) is currently at ${CURRENT_USAGE}%."
    MAILTO="tanujarora2703@gmail.com"
    echo "$MESSAGE" | mail -s "$SUBJECT" "$MAILTO"
    exit 1
else
    echo "Disk usage is within the threshold. No email notification sent."
    echo "Current Usage is $CURRENT_USAGE"
fi