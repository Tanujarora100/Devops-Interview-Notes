#!/bin/bash

WEBSITES=("www.navisite.com" "www.google.com" "www.bbc.co.uk")
LOG_FILE="$PWD/website_status.log"
echo "=============================================" >> "$LOG_FILE"
for website in "${WEBSITES[@]}"; do
        status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null "$website")
        if [[ "$status_code" -ne 200 ]]; then
            echo "$(date): Website $website is down. Status code: $status_code" | tee -a "$LOG_FILE"
            echo "Website $website is down. Status code: $status_code" | mail -s "CRITICAL: Website Down: $website" tanujarora2703@gmail.com
        else
            echo "$(date): Website $website is up. Status code: $status_code" | tee -a "$LOG_FILE"
        fi
    done
echo "=============================================" >> "$LOG_FILE"

