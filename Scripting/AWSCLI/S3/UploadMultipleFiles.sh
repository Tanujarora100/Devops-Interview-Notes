#!/bin/bash 
set -x
set -e 
set -o pipefail 
LOG_FILE="/home/$USER/s3_accesslog.log"
if [[ ! -f "$LOG_FILE" ]]; then 
 touch "$LOG_FILE"
fi
RETRY_LIMIT=3
log_message() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") $1" | tee -a "$LOG_FILE"
}
echo "$(date) Executing the MultiFile Upload Script....." >> "$LOG_FILE"
echo "================================================" >> "$LOG_FILE"
if ! aws sts get-caller-identity > /dev/null 2>&1; then 
    log_message "Credentials are not available to connect to the AWS account."
    exit 1
fi 

if [[ $? -lt 2 ]]; then 
 log_message "Please enter correct number of arguments" 
 exit 1
fi 

BUCKET_NAME=$1
shift 
if ! aws s3api head-bucket --bucket "$BUCKET_NAME" > /dev/null 2>&1; then 
 log_message "Bucket $BUCKET_NAME does not exist."
 log_message "Creating bucket with name: $BUCKET_NAME..." 
 aws s3api create-bucket --bucket "$BUCKET_NAME" --region $(aws configure get region) 
 exit_status=$?
 if [[ $exit_status -eq 0 ]]; then
  log_message "Bucket $BUCKET_NAME created successfully."
 else
  log_message "Failed to create bucket $BUCKET_NAME. Exiting..."
  exit 0
 fi 
 else 
 log_message "Bucket $BUCKET_NAME already exists."
fi 
for file in "$@"; do 
 if [[ ! -f "$file" ]]; then 
 log_message "$file does not exist, SKIPPING $file"
 continue 
fi 
FILE_NAME=$(basename "$file")
SUCCESS=false 

for ((i=1; i<=RETRY_LIMIT; i++)); do
        log_message "Attempting to upload $FILE_PATH to s3://$BUCKET_NAME/$FILE_NAME (Attempt $i)..."
        if aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$FILE_NAME" >> "$LOG_FILE" 2>&1; then
            log_message "Successfully uploaded $FILE_PATH to s3://$BUCKET_NAME/$FILE_NAME."
            SUCCESS=true
            break
        else
            log_message "Failed to upload $FILE_PATH. Retrying..."
        fi
done
if [[ "$SUCCESS" == "true" ]]; 
    log_message "Uploaded $FILE_PATH to $BUCKET_NAME" 
else 
    log_message "Failed to upload $FILE_PATH to $BUCKET_NAME after $RETRY_LIMIT" 
fi 
done 
echo "================================================" >> "$LOG_FILE"
echo "$(date) MultiFile Upload Script execution completed." >> "$LOG_FILE"
