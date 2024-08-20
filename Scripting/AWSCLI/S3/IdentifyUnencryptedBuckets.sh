#!/bin/bash
set -o pipefail
set -e

LOG_FILE="/home/$USER/s3_unencrypted_buckets.log"
EMAIL_RECIPIENT="your_email@gmail.com"
SES_SENDER="your-verified-email@example.com"

if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
fi

log_message() {
    echo "$(date +%Y-%m-%d %H:%M:%S): $1" >> "$LOG_FILE"
}

send_email() {
    local subject=$1
    local body=$2
    aws ses send-email --from "$SES_SENDER" --destination "ToAddresses=$EMAIL_RECIPIENT" \
        --message "Subject={Data=$subject,Charset=utf-8},Body={Text={Data=$body,Charset=utf-8}}" \
        >> "$LOG_FILE" 2>&1
}

if ! aws sts get-caller-identity >> /dev/null 2>&1; then
    log_message "Error: Credentials are not configured correctly..."
    exit 1
fi

BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

for bucket in $BUCKETS; do
    log_message "Processing bucket: $bucket"
    
    encrypted_status=$(aws s3api get-bucket-encryption --bucket $bucket --query 'ServerSideEncryptionConfiguration[].Rules.BucketKeyEnabled' --output text 2>&1 )

    if [[ $encrypted_status == "false" ]]; then
        log_message "Bucket $bucket is not encrypted. Action Required"
        send_email "Critical!: Unencrypted Bucket" "Bucket $bucket is not encrypted"
    else
        log_message "Bucket $bucket is encrypted... No Action Required"
    fi
done
