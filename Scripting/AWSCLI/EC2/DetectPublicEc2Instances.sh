#!/bin/bash 
set -o pipefail
set -e 

LOG_FILE="/users/$USER/ec2publicaccess.log"
if [[ ! -f "$LOG_FILE" ]]; then 
touch "$LOG_FILE"
fi

log_messages() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp: $1" >> "$LOG_FILE"
}
if ! aws sts get-caller-identity >> /dev/null 2>&1; then
    log_messages "Failed to get AWS STS caller identity"
    exit 1
fi
current_instances=$(aws ec2 describe-instances --query 'Reservations[].Instances[*].InstanceId' --output text)
for instance in $current_instances; do 
address=$(aws ec2 describe-instances --instance-ids "$instance" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
private_address=$(aws ec2 describe-instances --instance-ids "$instance" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)
if [[ -z "$address" ]]; then

    log_messages "No public IP address found for instance $instance"
    continue
else 
    log_messages "$address"
    log_messages "Instance $instance has public IP address: $public_ip_address, private address: $private_ip_address"
fi
done