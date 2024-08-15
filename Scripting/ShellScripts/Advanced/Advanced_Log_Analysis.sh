#!/bin/bash

LOG_FILE="/var/log/install.log"
LOG_ANALYSIS_LOG="$PWD/log_analysis.log"

# Check if the log file exists
if [[ ! -f "$LOG_FILE" ]]; then 
    echo "ERROR: Log file $LOG_FILE not found." | tee -a "$LOG_ANALYSIS_LOG"
    exit 1
fi 

# Ensure the analysis log file exists and is writable
if [[ ! -f "$LOG_ANALYSIS_LOG" ]]; then
    touch "$LOG_ANALYSIS_LOG"
elif [[ ! -w "$LOG_ANALYSIS_LOG" ]]; then
    echo "ERROR: Cannot write to $LOG_ANALYSIS_LOG." | tee -a "$LOG_ANALYSIS_LOG"
    exit 1
fi

echo "Starting log analysis..." | tee -a "$LOG_ANALYSIS_LOG"

# Initialize counters

error_types=( ["ERROR"]=0 ["WARNING"]=0 ["CRITICAL"]=0 )

# Count occurrences of each error type
while IFS= read -r line; do
    for key in "${!error_types[@]}"; do
        if echo "$line" | grep -q "$key"; then
            ((error_types["$key"]++))
        fi
    done
done < "$LOG_FILE"

echo "Error Type Summary:" | tee -a "$LOG_ANALYSIS_LOG"
for key in "${!error_types[@]}"; do
    echo "$key: ${error_types[$key]}" | tee -a "$LOG_ANALYSIS_LOG"
done

echo "Detailed Error Message Counts:" | tee -a "$LOG_ANALYSIS_LOG"
grep -E "ERROR|WARNING|CRITICAL" "$LOG_FILE" | sort | uniq -c | sort -nr | tee -a "$LOG_ANALYSIS_LOG"

echo "Log analysis complete." | tee -a "$LOG_ANALYSIS_LOG"
