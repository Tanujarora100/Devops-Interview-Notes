#!/bin/bash
AWS_ACCOUNT_IDS=$(aws organizations list-accounts --query "Accounts[*].id" --output text)
MASTER_ACCOUNT_PROFILE="Master_Account_Profile"
CROSS_ACCOUNT_ROLE_NAME="CROSS_Account_Role"
for ACCOUNT_ID in $AWS_ACCOUNT_IDS; do
  echo "Processing account $ACCOUNT_ID"
  CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$ACCOUNT_ID:role/$CROSS_Account_Role \
    --role-session-name EnforceS3Encryption \
    --profile $MASTER_ACCOUNT_PROFILE\
    --query 'Credentials[SecretAccessKey,SessionToken,AccessKeyId]'\
    --output json
  )
  export AWS_ACCESS_KEY_ID=$(echo "$CREDENTIALS" | awk '{print $1}')
  export AWS_SECRET_ACCESS_KEY=$(echo "$CREDENTIALS" | awk '{print $3}')
  export AWS_SESSION_TOKEN=$(echo "$CREDENTIALS" | awk '{print $2}')
S3_bucket_list= $(aws s3api list-buckets --output text )
for bucket in $S3_bucket_list; do 
  echo "Enforcing encryption on bucket $bucket"
  CURRENT_STATUS=$(aws s3api get-bucket-encryption\
   --bucket $bucket --query 'ServerSideEncryptionConfiguration.BucketKeyEnabled'
  )
  if [ "$CURRENT_STATUS" = "False" ]; then
   echo "Encryption not enabled on bucket $bucket. Enabling..."
   aws s3api put-bucket-encryption \
     --bucket $bucket \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
    echo "Encryption enabled on bucket $bucket"
  else
   echo "Encryption already enabled on bucket $bucket"
  fi
done
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
done