#!/bin/bash

ACCOUNT_IDS=$(aws organizations list-accounts --query 'Accounts[*].Id' --output text)

MASTER_ACCOUNT_PROFILE="master-account"
CROSS_ACCOUNT_ROLE="OrganizationAccountAccessRole"

REPORT_FILE="$PWD/elb_inventoryreport.txt"
echo "Account,Listener Description" > $REPORT_FILE
echo "======================================" >> $REPORT_FILE

for ACCOUNT_ID in $ACCOUNT_IDS; do 
    echo "Processing $ACCOUNT_ID ....."
    CREDENTIALS=$(aws sts assume-role \
    --role-arn arn:aws:iam::$ACCOUNT_ID:role/$CROSS_ACCOUNT_ROLE \
    --role-session-name list-load-balancers \
    --profile $MASTER_ACCOUNT_PROFILE \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)
    export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | awk '{print $1}')
    export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | awk '{print $2}')
    export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | awk '{print $3}')

    echo "Listing load balancers in account $ACCOUNT_ID ....."

    CURRENT_ELB=$(aws elb describe-load-balancers \
    --query 'LoadBalancerDescriptions[*].ListenerDescriptions[*]' \
    --output text)

    echo "Account: $ACCOUNT_ID, Listener Description:" >> $REPORT_FILE
    echo "$CURRENT_ELB" >> $REPORT_FILE
    echo "============================" >> $REPORT_FILE

    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
done 

echo "Load balancer inventory report generated at $REPORT_FILE."
