#!/bin/bash
read -p "Enter Directory" DIRECTORY
if [[ ! -d "$DIRECTORY" ]]; then 
    echo "Invalid Directory"
    exit 1
fi 
MB_SIZE=$(du -m "$DIRECTORY" | cut -f1 )
echo "Size of $DIRECTORY in MB: $MB_SIZE"
KB_SIZE=$(du -sh "$DIRECTORY" | cut -f1)
echo "Size of $DIRECTORY in KB: $KB_SIZE"
