#!/bin/bash

# Script to monitor disk usage and report

# Set the path for the log file
DATE= $(date)
touch "/Users/tanujarora/disk_usage_report_$DATE.log"
LOG_FILE="/Users/tanujarora/Desktop/disk_usage_report_$DATE.log"

# Get disk usage with df
echo "Disk Usage Report - $(date)" >> "$LOG_FILE"
echo "---------------------------------" >> "$LOG_FILE"
df -h >> "$LOG_FILE"

# Get top 10 directories consuming space
echo "" >> "$LOG_FILE"
echo "Top 10 Directories by Size:" >> "$LOG_FILE"
du -x / | sort -nr | head -10 >> "$LOG_FILE"

# # Send the log via email
# MAIL_RECIPIENT="recipient@example.com"
# MAIL_SUBJECT="Disk Usage Report"
# mail -s "$MAIL_SUBJECT" "$MAIL_RECIPIENT" < "$LOG_FILE"

# End of script
```