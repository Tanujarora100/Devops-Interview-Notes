ACCOUNT_IDS=$(aws organizations list-accounts --query 'Accounts[*].Id' --output text)

MASTER_ACCOUNT_PROFILE="master-account"
CROSS_ACCOUNT_ROLE="OrganizationAccountAccessRole"


REPORT_FILE="load_balancer_report.txt"

echo "Generating report: $REPORT_FILE"
echo "Account ID, Listener Description" > $REPORT_FILE

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

    CURRENT_ELBS=$(aws elb describe-load-balancers \
    --query 'LoadBalancerDescriptions[*].ListenerDescriptions[*]' \
    --output json)

    echo "Account: $ACCOUNT_ID, Listener Description:" >> $REPORT_FILE
    echo "$CURRENT_ELBS" >> $REPORT_FILE
    echo "Deleting the $ACCOUNT_ID" ELB >> $REPORT_FILE
    echo "============================" >> $REPORT_FILE
    echo "CURRENT_ELBS" | jq -c '.LoadBalancerDescriptions[]' | while read -r lb; do
        ELB_NAME=$(jq -r '.LoadBalancerName')
        ELB_ARN=$(jq -r '.LoadBalancerArn')
        echo "Deleting $ELB_NAME at $(date +%Y-%m-%d)" >> $REPORT_FILE
        aws elb delete-load-balancer --load-balancer-arn $ELB_ARN
    done 
    sleep 120
   echo "============================" >> $REPORT_FILE
   echo "All ELB's are deleted across $ACCOUNT_ID ..." >> $REPORT_FILE
   echo "POST VERIFICATION " >> $REPORT_FILE
   echo "============================" >> $REPORT_FILE
   CURRENT_ELB=$(aws elb describe-load-balancers \
    --query 'LoadBalancerDescriptions[*].ListenerDescriptions[*]' \
    --output text) 
    echo "$CURRENT_ELB" >> "$REPORT_FILE" 
    echo "============================" >> $REPORT_FILE
done