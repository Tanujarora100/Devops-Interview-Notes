#!/bin/bash
set -o pipefail 
set -e 

LOG_FILE="/home/$USER/s3_backuplog.log"

log_message() {
	 echo "$(date +"%Y-%m-%d %H:%M:%S") $1" | tee -a "$LOG_FILE"
}
if ! aws sts get-caller-identity > /dev/null 2>&1; then
	log_message "Error: Credentials are not authorized"
	exit 1
fi 

if [[ $# -lt 2 ]]; then 
	log_message "Error: Number of arguments are invalid."
	exit 1
fi 

DIRECTORY_PATH=$1

if [[ ! -d "$DIRECTORY_PATH" ]]; then 
	log_message "Invalid Directory Path Provided."
	exit 1
fi 

BUCKET_NAME=$2

if ! aws s3api head-bucket --bucket "$BUCKET_NAME" > /dev/null 2>&1; then 
	log_message "Invalid Bucket Name Provided or the bucket does not exist."
	exit 1
fi 

ARCHIVE_FILE_NAME="directory_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
ARCHIVE_BACKUP_PATH="/home/$USER/backups"

if [[ ! -d "$ARCHIVE_BACKUP_PATH" ]]; then 
	log_message "Backup directory is not present. Creating it."
	mkdir -p "$ARCHIVE_BACKUP_PATH"
fi 

if ! tar -czvf "$ARCHIVE_BACKUP_PATH/$ARCHIVE_FILE_NAME" -C "$DIRECTORY_PATH" .; then
	log_message "Failed to create a compressed backup."
	exit 1
fi 

if aws s3 cp "$ARCHIVE_BACKUP_PATH/$ARCHIVE_FILE_NAME" s3://$BUCKET_NAME/$ARCHIVE_FILE_NAME; then
	log_message "$ARCHIVE_BACKUP_PATH/$ARCHIVE_FILE_NAME copied to $BUCKET_NAME."
else 
	log_message "$ARCHIVE_BACKUP_PATH/$ARCHIVE_FILE_NAME failed to copy to $BUCKET_NAME."
	exit 1
fi 

log_message "Starting cleanup of old backups."
CURRENT_OBJECTS=$(aws s3api list-objects --bucket "$BUCKET_NAME" --query 'Contents[?LastModified<`date -d "-7 days" +%Y-%m-%d`].{Key:Key}' --output text)

for OBJECT in $CURRENT_OBJECTS; do 
	log_message "Deleting old backup: $OBJECT"
	if aws s3 rm "s3://$BUCKET_NAME/$OBJECT"; then
		log_message "Successfully deleted $OBJECT."
	else
		log_message "Failed to delete $OBJECT."
	fi
done

log_message "Automated Backup and Cleanup Script Completed" 
log_message "======================================================"
