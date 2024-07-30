#!/bin/bash
DIRECTORY="/Users/tanujarora/Downloads"
if [ ! -d "$DIRECTORY" ]; then 
    echo " Directory does not exist"
    exit 1
fi 
file_name="tanuj.txt"
if [ ! -f "$DIRECTORY/$file_name" ]; then
    touch "$DIRECTORY/$file_name"
    echo "File created successfully"
    exit 0
else
    echo "File already exists"
    exit 1
fi 