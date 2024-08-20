#!/bin/bash 
set -o pipefail 
set -e 
# set -x 
LOG_FILE="/users/$USER/unused_key_pairs.log"
if [[ ! -f "$LOG_FILE" ]]; then 
    touch "$LOG_FILE"
fi
log_messages() {
     TIMESTAMP=$(date +%Y-%m-%d)
     echo "$TIMESTAMP: $1" >> "$LOG_FILE"
}
if ! aws sts get-caller-identity >> /dev/null 2>&1; then
    log_messages "ERROR: Credentials are not configured correctly"
    exit 1
fi 

current_keypairs=$(aws ec2 describe-key-pairs --query 'KeyPairs[*].KeyName' --output text)
used_keypairs=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].keyName' --output text)

unused_keypairs=$(comm -23 <(echo "$current_keypairs" | sort) <(echo "$used_keypairs" | sort))

if [[ -z "$unused_keypairs" ]]; then
log_messages "No unused key pairs"
else 
    for key in $unused_keypairs; do
    log_messages "Found unused key pair: $key"
    exit_status=$(aws ec2 delete-key-pair --key-name "$key")
    if [[ "$exit_status" -eq 0 ]]; then
       log_messages "Deleted unused key pair: $key"
    else
        log_messages "ERROR: Failed to delete key pair: $key"
    fi
    done 
fi
log_messages "$(date) Script Execution Completed" 
log_messages "==================================="