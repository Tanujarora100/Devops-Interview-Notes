#!/bin/bash 
MASTER_ACCOUNT_PROFILE="master-account"
CROSS_ACCOUNT_ROLE_NAME="OrganizationAccountAccessRole"
ACCOUNT_ID=$(aws organizations list-accounts --profile "$MASTER_ACCOUNT_PROFILE"\
--query 'Accounts[*].Id' --output text)
for ACCOUNT_ID in $ACCOUNT_IDS; do
    echo "Processing Account ID: $ACCOUNT_ID"
    CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$ACCOUNT_ID:role/$CROSS_ACCOUNT_ROLE_NAME \
                                      --role-session-name "S3CleanupSession" \
                                      --profile $MASTER_ACCOUNT_PROFILE \
                                      --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
                                      --output text)
    export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | awk '{print $1}')
    export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | awk '{print $2}')
    export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | awk '{print $3}')
    BUCKETS=$(aws s3api list-buckets --query 'Buckets[*].name' -output text)
    for bucket in $BUCKETS; do 
    echo "Processing Bucket: $bucket"
    OBJECT_COUNT=$(aws s3api get-object-count --bucket $bucket --output text | wc -l )
    if [[ $OBJECT_COUNT -eq 0 ]]; then
    echo "No objects found in bucket $bucket. Deleting bucket..."
    aws s3api delete-bucket --bucket $bucket
    else
    echo "Objects found in bucket $bucket. Skipping deletion..."
    fi
    done
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    echo "Finished processing Account ID: $ACCOUNT_ID"
    echo "----------------------------------------------------"
    sleep 10  # Add a delay to avoid hitting AWS API rate limits
done 
echo "All Accounts Processed"