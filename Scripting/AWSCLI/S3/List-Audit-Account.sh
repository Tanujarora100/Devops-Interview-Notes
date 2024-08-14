#!/bin/bash

if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found. Please install it to run this script."
    exit
fi
echo "S3 Status " > $PWD/s3status.log
echo "========================" >> $PWD/s3status.log
echo "Retrieving the list of S3 buckets in your AWS account..."
BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output table)
echo "$BUCKETS" >> $PWD/s3status.log
if [ -z "$BUCKETS" ]; then
    echo "No S3 buckets found in your AWS account." >> $PWD/s3status.log
else
    echo "The following S3 buckets were found:"
    for BUCKET in $BUCKETS; do
        echo "- $BUCKET" >> $PWD/s3status.log
    done
fi
