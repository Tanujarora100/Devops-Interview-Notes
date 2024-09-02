#!/bin/bash

MASTER_ACCOUNT_PROFILE="master-account"
CROSS_ACCOUNT_ROLE="cross-account-role"
ACCOUNT_IDS=$(aws organizations list-accounts --query 'Accounts[*].Id' --output text)
# [ account1, account2m,]
for ACCOUNT_ID in $ACCOUNT_IDS; do
    echo "Processing S3 cleanup for $ACCOUNT_ID"
    CREDENTIALS=$(aws sts assume-role \
    --role-arn arn:aws:iam::$ACCOUNT_ID:role/$CROSS_ACCOUNT_ROLE \
    --role-session-name S3CleanupSession \
    --profile $MASTER_ACCOUNT_PROFILE \
    --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
    --output text)

    export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | awk '{print $1}')
    export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | awk '{print $2}')
    export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | awk '{print $3}')
    
    echo "Listing S3 buckets for $ACCOUNT_ID..."
    CURRENT_BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output text)
    
    for BUCKET in $CURRENT_BUCKETS; do
        echo "Processing bucket: $BUCKET in account $ACCOUNT_ID..."

        OBJECT_COUNT=$(aws s3api list-objects-v2 --bucket "$BUCKET" --query 'Contents[].Key' --output text | wc -l)

        if [ "$OBJECT_COUNT" -gt 0 ]; then
            echo "Deleting $OBJECT_COUNT objects in bucket $BUCKET..."
            OBJECTS=$(aws s3api list-objects-v2 --bucket "$BUCKET" --query 'Contents[].{Key: Key}' --output json)
            aws s3api delete-objects --bucket "$BUCKET" --delete "$(echo $OBJECTS | jq -c '{Objects: .}')"
            if [ $? -eq 0 ]; then
                echo "Objects in bucket $BUCKET deleted successfully."
                aws s3api delete-bucket --bucket "$BUCKET"
                if [ $? -eq 0 ]; then
                    echo "Bucket $BUCKET deleted successfully."
                else
                    echo "Failed to delete bucket $BUCKET."
                fi
            else
                echo "Issue in deleting the objects in bucket $BUCKET."
            fi
        else
            echo "No objects in bucket $BUCKET."
            aws s3api delete-bucket --bucket "$BUCKET"
            if [ $? -eq 0 ]; then
                echo "Bucket $BUCKET deleted successfully."
            else
                echo "Failed to delete bucket $BUCKET."
            fi
        fi
    done
    
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN

    echo "Finished processing $ACCOUNT_ID."
done

echo "S3 cleanup completed across all accounts."
