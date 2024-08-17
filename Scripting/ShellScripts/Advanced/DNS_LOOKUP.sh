#!/bin/bash 
read -p "Enter the DNS file" FILE_NAME
if [[ ! -f "$FILE_NAME" ]]; then 
    echo "DNS File is not found"
    exit 1
fi 
while IFS = read -r domain; do 
  ip=$(dig +short "$domain")
  if [[ -z "$ip" ]]; then 
    echo "$domain" could not be found
 else 
    echo "$domain: $ip"
fi 
done < "$FILE_NAME"