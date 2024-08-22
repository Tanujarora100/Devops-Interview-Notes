#!/bin/bash 
FILE_PATH="$PWD/numbers.txt"
SALES_PATH="$PWD/sales.txt"
awk '{sum+=$1} END {print "Total Sum",sum}' "$FILE_PATH" 
sales_data=$(awk '{sum+=$2} END {print "TOTAL SUM:",sum}' "$SALES_PATH")
echo "$sales_data"