#!/bin/bash 
if [ -z "$1" ]; then
    echo "Error: No filename provided."
    echo "Usage: $0 <filename>"
    exit 1
fi
FILE_TYPE=$1
if [ -d "$FILE_TYPE" ]; then
    echo "OUTPUT: Input is a directory."
elif [ -f "$FILE_TYPE" ]; then
   echo "OUTPUT: Input is a file"
else
    echo "Error: Input is neither a file nor a directory."
fi
