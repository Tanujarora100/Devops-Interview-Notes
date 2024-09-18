#!/bin/bash 

FILE_LOCATION="/Users/tanujarora/Desktop/Projects/Devops/Python/IP.txt"
OUTPUT_DIR="/Users/tanujarora/Desktop/Projects/Devops/Python/Result.txt"
if [ ! -f "$FILE_LOCATION" ]; then 
    echo "File not found at $FILE_LOCATION"
    exit 1
fi 
sort "$FILE_LOCATION" | uniq -c | awk '$1==1 {print $2}' > "$OUTPUT_DIR"

# Check if the write operation was successful
if [ $? -ne 0 ]; then 
    echo "Error writing to output file"
    exit 1
fi 

echo "Unique IP addresses have been written to $OUTPUT_DIR"