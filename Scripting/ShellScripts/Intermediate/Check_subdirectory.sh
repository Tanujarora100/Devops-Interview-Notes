#!/bin/bash 
DIRECTORY="/Users/tanujarora/Desktop/Projects/Devops/Devops-Notes"
if [ -d "$DIRECTORY" ]; then 
    echo "Directory not found " >> /dev/null 
    exit 1
fi 
echo "Files in $DIRECTORY:"
find "$DIRECTORY" -type f -exec | du -sh {} +| sort -h >> "$PWD/tst.txt"
echo "Total size of files in $DIRECTORY:"
du -sh "$DIRECTORY"
