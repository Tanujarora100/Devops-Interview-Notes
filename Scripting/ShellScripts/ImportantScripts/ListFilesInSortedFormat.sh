#!/bin/bash 
DIRECTORY="/Users/tanujarora/Desktop/Projects/Devops/Scripting"
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: Directory '$DIRECTORY' does not exist."
    exit 1
fi
du -ah "$DIRECTORY" | sort -rh