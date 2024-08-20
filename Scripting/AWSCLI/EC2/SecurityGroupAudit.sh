#!/bin/bash 
set -o pipefail 
set -e 

LOG_FILE="/users/$USER/security_group_audit.log"
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

log_messages "Security Group Audit Report"
log_messages "=========================================="

security_groups=$(aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupId,GroupName]' --output text)
while read -r sg_id sg_name; do
    log_messages "Checking Security Group: $sg_name ($sg_id)"
    ingress=$(aws ec2 describe-security-groups --group-ids "$sg_id" --query 'SecurityGroups[*].IpPermissions[*].{IP:IpRanges[*].CidrIp,Proto:IpProtocol,PortFrom:FromPort,PortTo:ToPort}' --output text)
    if echo "$ingress" | grep -qE '0\.0\.0\.0/0|::/0'; then
        log_messages "UNRESTRICTED INGRESS found in Security Group: $sg_name ($sg_id)"
        log_messages "$ingress"
    fi
    
    egress=$(aws ec2 describe-security-groups --group-ids "$sg_id" --query 'SecurityGroups[*].IpPermissionsEgress[*].{IP:IpRanges[*].CidrIp,Proto:IpProtocol,PortFrom:FromPort,PortTo:ToPort}' --output text)
    if echo "$egress" | grep -qE '0\.0\.0\.0/0|::/0'; then
        log_messages "UNRESTRICTED EGRESS found in Security Group: $sg_name ($sg_id)"
        log_messages "$egress"
    fi
    
    log_messages "------------------------------------------"
done <<< "$security_groups"

log_messages "Security Group Audit Completed"
