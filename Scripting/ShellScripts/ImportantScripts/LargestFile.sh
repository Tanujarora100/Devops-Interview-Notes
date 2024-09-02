#!/bin/bash 
DIRECTORY="/Users/tanujarora/Desktop/Projects/Devops/Scripting"

if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi

largest_file=$(find "$DIRECTORY" -type f -exec du -ah {} + | sort -rh | head -n 1 | awk '{print $2}')
echo "Largest file in '$DIRECTORY': $(basename "$largest_file")"