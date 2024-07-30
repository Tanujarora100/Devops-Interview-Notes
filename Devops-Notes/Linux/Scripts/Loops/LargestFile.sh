#!/bin/bash
DIRECTORY="/Users/tanujarora/Downloads/"  # Removed space after '='

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then 
    echo "Directory $DIRECTORY does not exist."
    exit 1
fi 
if [ ! -d "$DIRECTORY" ]; then
echo "Directory $DIRECTORY does not exist."
exit 1
fi
biggest_file=""
largest_size=0
echo "------------------- $(date)"
for file in "$DIRECTORY"/*; do
if [ -f "$file" ]; then
file_size=$(du -sh "$file" | awk '{print $1}')
if [ "$file_size" -gt "$largest_size" ]; then
largest_size="$file_size"
biggest_file="$file"
fi
fi
done
if [ -n "$biggest_file" ]; then
echo "Largest file: $biggest_file"
echo "Size: $largest_size bytes"
else
echo "No files found in the directory."
fi
