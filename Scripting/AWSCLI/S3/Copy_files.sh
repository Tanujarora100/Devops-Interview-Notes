#!/bin/bash
set -x 
set -e  
set -o pipefail

LOG_FILE="/home/$USER/s3_apilog.log"
if ! aws sts get-caller-identity > /dev/null 2>&1; then 
    echo "Credentials are not available to connect to the AWS account" | tee -a "$LOG_FILE"
    exit 1
fi 

FILE_PATH=$1
BUCKET_NAME=$2

if [[ ! -f "$FILE_PATH" ]]; then
    echo "File not found at $FILE_PATH" | tee -a "$LOG_FILE"
    exit 1
fi 

BUCKETS_PRESENT=$(aws s3api list-buckets --query "Buckets[].Name" --output text)
if echo "$BUCKETS_PRESENT" | grep -w "$BUCKET_NAME" > /dev/null; then 
    echo "Bucket $BUCKET_NAME exists" | tee -a "$LOG_FILE"
    echo "$(date) Copying the required file to $BUCKET_NAME" | tee -a "$LOG_FILE"
    echo "========================================" | tee -a "$LOG_FILE"
    
    aws s3 cp "$FILE_PATH" s3://"$BUCKET_NAME"/"$(basename "$FILE_PATH")" | tee -a "$LOG_FILE"
    exit_status=$? 
    
    if [[ "$exit_status" -eq 0 ]]; then
        echo "$(date) File copied successfully to $BUCKET_NAME" | tee -a "$LOG_FILE"
        echo "$(date) All tasks completed successfully" | tee -a "$LOG_FILE"
        exit 0
    else 
        echo "$(date) Copy Task failed" | tee -a "$LOG_FILE"
        exit 1
    fi
else 
    echo "Bucket $BUCKET_NAME does not exist" | tee -a "$LOG_FILE"
    echo "Cannot copy the required file to $BUCKET_NAME" | tee -a "$LOG_FILE"
    exit 1
fi
