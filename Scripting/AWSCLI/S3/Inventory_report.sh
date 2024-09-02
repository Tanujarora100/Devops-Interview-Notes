AWS_ACCOUNT_IDS=$(aws organizations list-accounts --query "Accounts[*].id" --output text)
MASTER_ACCOUNT_PROFILE="Master_Account_Profile"
CROSS_ACCOUNT_ROLE_NAME="CROSS_Account_Role"
echo "Inventory Report" >> "$PWD/s3InventoryReport.txt"
echo "==========================================" >> "$PWD/s3InventoryReport.txt"
echo "Current Date is $(date)" >> "$PWD/s3InventoryReport.txt"
for account in $AWS_ACCOUNT_IDS; do 
  echo "Processing Inventory report for $account ...." >> "$PWD/s3InventoryReport.txt"
  CREDENTIALS=$(aws sts assume-role --role-arn arn:aws:iam::$ACCOUNT_ID:role/$CROSS_Account_Role \
      --role-session-name EnforceS3Encryption \
      --profile $MASTER_ACCOUNT_PROFILE\
      --query 'Credentials[SecretAccessKey,SessionToken,AccessKeyId]'\
      --output json
    )
  export AWS_ACCESS_KEY_ID=$(echo "$CREDENTIALS" | awk '{print $1}')
    export AWS_SECRET_ACCESS_KEY=$(echo "$CREDENTIALS" | awk '{print $3}')
    export AWS_SESSION_TOKEN=$(echo "$CREDENTIALS" | awk '{print $2}')