#!/bin/bash 
MASTER_ACCOUNT_PROFILE="MASTER_ACCOUNT_PROFILE"
CROSS_ACCOUNT_ROLE_NAME="CROSS_ACCOUNT_ROLE_NAME"
ACCOUNT_ID=$(aws organizations list-accounts --profile "$MASTER_ACCOUNT_PROFILE"\
--query "Accounts[*].id" --output text)

for account_id in $ACCOUNT_ID; do
 echo "Processing account $account_id"
 CREDENTIALS=$(aws sts-assume-role --role-arn arn:aws:iam::$account_id:role/$CROSS_ACCOUNT_ROLE_NAME\
 --role-session-name "List Down Buckets" \
 --profile "$MASTER_ACCOUNT_PROFILE" \
  --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
  --output text)



export AWS_ACCESS_KEY_ID=$(echo "$CREDENTIALS" | awk '{print $1}')
export AWS_SECRET_ACCESS_KEY=$(echo "$CREDENTIALS" | awk '{print $2}')
export AWS_SESSION_TOKEN=$(echo "$CREDENTIALS" | awk '{print $3}')
bucket_names= $(aws s3api --list-buckets --query 'Buckets[*].name' --output text)

# Printing the bucket names present in the account
echo "ACCOUNT PROCESSED: $account_id, Buckets Present in the $account_id are: $bucket_names"


unset $AWS_ACCESS_KEY_ID 
unset $AWS_SECRET_ACCESS_KEY
unset $AWS_SESSION_TOKEN
done 
