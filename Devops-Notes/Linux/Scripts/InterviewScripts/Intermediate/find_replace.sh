#!/bin/bash

# Prompt for the directory
read -p "Enter the directory you want to search: " DIRECTORY
if [ -z "$DIRECTORY" ]; then 
    echo "Error: Invalid argument. No directory provided."
    exit 1
fi

# Check if the provided argument is a valid directory
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Invalid directory."
    exit 1
fi

# Prompt for the search string
read -p "Enter the string you want to search for: " SEARCHED
if [ -z "$SEARCHED" ]; then 
    echo "Error: Invalid argument. No search string provided."
    exit 1
fi

read -p "Enter the replacement string: " REPLACEMENT
if [ -z "$REPLACEMENT" ]; then 
    echo "Error: Invalid argument. No replacement string provided."
    exit 1
fi

for file in "$DIRECTORY"/*; do 
    if [ -f "$file" ]; then 
        sed -i "s/$SEARCHED/$REPLACEMENT/g" "$file"
        echo "Replaced '$SEARCHED' with '$REPLACEMENT' in $file"
    fi 
done
