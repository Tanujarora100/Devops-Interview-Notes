#!/bin/bash 
DIRECTORY="/Users/tanujarora/Downloads"
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory not found."
    exit 1
fi

total_directory=$(find "$DIRECTORY" -type d | wc -l)
total_files=$(find "$DIRECTORY" -type f | wc -l)
echo "Total number of directories: $total_directory"
echo "Total number of files: $total_files"
