#!/bin/bash 
read -p "Enter the directory where you want to search "  DIRECTORY
if [ -z "$DIRECTORY" ]; then 
    echo "Please enter a directory"
    exit 1
fi 
read -p "Enter the extension you want to search for " EXTENSION 
if [ -z "$EXTENSION" ]; then 
    echo "Please enter an extension"
    exit 1
fi 
find "$DIRECTORY" -type f -name "*.$EXTENSION" -exec echo {} \; 
#END OF SCRIPT