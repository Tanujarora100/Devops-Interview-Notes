#!/bin/bash
FILE_PATH="/home/tanuj/abc.txt"
if [ ! -f "$FILE_PATH" ]; then 
    echo "File does not exist"
    exit 1
fi 
RESULT_LOCATION="/home/tanuj/result.txt"
sort "$FILE_PATH" | uniq > "$RESULT_LOCATION"

if [ $? -ne 0 ]; then
    echo "Error occurred while processing the file"
    exit 1
else 
    echo "Unique IPs retrieved successfully"
fi