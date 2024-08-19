#!/bin/bash 
set -o pipefail
set -e 

LOG_FILE="/users/$USER/s3_unencrypted_buckets.log"
if [[ ! -f "$LOG_FILE" ]]; then
 touch "$LOG_FILE"
fi
> "$LOG_FILE"
log_message() {
    echo "$(date +%Y-%m-%d): $1" >> "$LOG_FILE"
}
if ! aws sts get-caller-identity >> /dev/null 2>&1; then
 log_message "Error: Credentials are not configured correctly..." 
 exit 1
fi 
BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output text)
for bucket in $BUCKETS; do 
 log_message " Processing bucket :$bucket"
 encrypted_status=$(aws s3api get-bucket-encryption --bucket $bucket --query 'ServerSideEncryptionConfiguration[].Rules.BucketKeyEnabled' --output text )
 if [[ $encrypted_status == "true" ]]; then
  log_message "Bucket $bucket is encrypted... No Action Required"
 else
  log_message "Bucket $bucket is not encrypted. Action Required"
  echo "Bucket $bucket is not encrypted" | mail -s "Critical!:Unencrypted Bucket" tanujarora2703@gmail.com | tee -a "$LOG_FILE"
 fi
done