#!/bin/bash
set -e 
set -o pipefail 
# f the file containing IP addresses is provided as an argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi


input_file=$1
if [ ! -f "$input_file" ]; then
  echo "File not found!" >> /dev/null
  exit 1
fi

sort "$input_file" | uniq -c > ip_counts.txt
sort -u "$input_file" > unique_ip_counts.txt
echo "IP address counts:"
cat ip_counts.txt
