#!/bin/bash

ADMIN_EMAIL="admin@example.com"
CURRENT_DATE=$(date "+%Y-%m-%d")
FUTURE_DATE=$(date -d "+7 days" "+%Y-%m-%d")

expiring_users=$(chage -l | awk -v start="$CURRENT_DATE" -v end="$FUTURE_DATE" '$1 >= start && $1 <= end {print $1}')

if [ -n "$expiring_users" ]; then
    echo "The following user accounts are set to expire within the next 7 days:" > /tmp/expiry_report.txt
    echo "$expiring_users" >> /tmp/expiry_report.txt
    mail -s "User Account Expiry Notification" "$ADMIN_EMAIL" < /tmp/expiry_report.txt
    echo "Expiry notification sent to $ADMIN_EMAIL."
else
    echo "No user accounts are set to expire within the next 7 days." >>/expiry_report.txt

fi
