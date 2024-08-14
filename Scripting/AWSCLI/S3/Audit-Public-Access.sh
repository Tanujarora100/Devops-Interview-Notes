#!/bin/bash
MASTER_ACCOUNT_PROFILE="MASTER_ACCOUNT_PROFILE"
CROSS_ACCOUNT_ROLE_NAME="CROSS_ACCOUNT_ROLE_NAME"
ACCOUNT_IDS=$(aws organizations list-accounts --profile "$MASTER_ACCOUNT_PROFILE" \
--query "Accounts[*].Id" --output text)

for ACCOUNT_ID in $ACCOUNT_IDS; do 
    echo "Processing account with ID: $ACCOUNT_ID ..."
    CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$ACCOUNT_ID:role/$CROSS_ACCOUNT_ROLE_NAME \
    --role-session-name "ListS3PublicAccessSession" \
    --profile "$MASTER_ACCOUNT_PROFILE" \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)
    export AWS_ACCESS_KEY_ID=$(echo "$CREDENTIALS" | awk '{print $1}')
    export AWS_SECRET_ACCESS_KEY=$(echo "$CREDENTIALS" | awk '{print $2}')
    export AWS_SESSION_TOKEN=$(echo "$CREDENTIALS" | awk '{print $3}')

    echo "Listing public S3 buckets in account $ACCOUNT_ID..."
    BUCKET_NAMES=$(aws s3api list-buckets --query "Buckets[*].Name" --output text)

    for BUCKET_NAME in $BUCKET_NAMES; do
        PUBLIC_ACCESS_STATUS=$(aws s3api get-public-access-block --bucket $BUCKET_NAME \
            --query "PublicAccessBlockConfiguration.BlockPublicPolicy" --output text 2>/dev/null)

        if [[ $PUBLIC_ACCESS_STATUS == "true" ]]; then
            echo "Bucket $BUCKET_NAME does not have public access enabled."
        else
            echo "Bucket $BUCKET_NAME has public access enabled."
        fi
    done
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    echo "Finished processing account with ID: $ACCOUNT_ID"
done

echo "All accounts have been processed."
