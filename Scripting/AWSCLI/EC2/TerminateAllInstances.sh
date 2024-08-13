#!/bin/bash

MASTER_ACCOUNT_PROFILE="master-account-profile"
CROSS_ACCOUNT_ROLE_NAME="OrganizationAccountAccessRole"
REGIONS=$(aws ec2 describe-regions --profile $MASTER_ACCOUNT_PROFILE --query "Regions[*].RegionName" --output text)
ACCOUNT_IDS=$(aws organizations list-accounts --profile $MASTER_ACCOUNT_PROFILE --query 'Accounts[*].Id' --output text)

for ACCOUNT_ID in $ACCOUNT_IDS; do
    echo "Processing Account ID: $ACCOUNT_ID"
    CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$ACCOUNT_ID:role/$CROSS_ACCOUNT_ROLE_NAME \
                                      --role-session-name "TerminateEC2Session" \
                                      --profile $MASTER_ACCOUNT_PROFILE \
                                      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
                                      --output text)
    ACCESS_KEY=$(echo $CREDENTIALS | awk '{print $1}')
    SECRET_KEY=$(echo $CREDENTIALS | awk '{print $2}')
    SESSION_TOKEN=$(echo $CREDENTIALS | awk '{print $3}')
    export AWS_ACCESS_KEY_ID=$ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY=$SECRET_KEY
    export AWS_SESSION_TOKEN=$SESSION_TOKEN
    for REGION in $REGIONS; do
        echo "Processing Region: $REGION for Account ID: $ACCOUNT_ID"
        INSTANCE_IDS=$(aws ec2 describe-instances --region "$REGION" \
                         --query "Reservations[*].Instances[*].InstanceId" --output text)

        if [ -n "$INSTANCE_IDS" ]; then
            echo "Terminating instances: $INSTANCE_IDS in region $REGION for account ID: $ACCOUNT_ID"
            aws ec2 terminate-instances --region "$REGION" --instance-ids $INSTANCE_IDS
            aws ec2 wait instance-terminated --region "$REGION" --instance-ids $INSTANCE_IDS
            echo "All instances have been terminated in region $REGION for account ID: $ACCOUNT_ID."
        else
            echo "No running instances found in region $REGION for account ID: $ACCOUNT_ID."
        fi
    done
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    echo "Finished processing account ID: $ACCOUNT_ID"
done

echo "All accounts have been processed."
