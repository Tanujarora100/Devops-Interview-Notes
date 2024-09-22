#!/bin/bash

set -e 
if [ ! -f /etc/passwd ]; then
  echo "The /etc/passwd file does not exist!"
  exit 1
fi

# Use AWK to extract the user ID (third field) and sum them up
sum=$(awk -F: '{ sum += $3 } END { print sum }' /etc/passwd)

# Output the sum of the user IDs
echo "The sum of all user IDs in /etc/passwd is: $sum"
