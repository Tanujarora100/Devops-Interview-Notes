#!/bin/bash 
read -p "Enter directory" DIRECTORY
if [ -z "$DIRECTORY" ]; then 
    echo "Invalid Argument"
    exit 1
fi 
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory does not exist"
    exit 1
fi 
read -p "Enter the prefix you want to add " PREFIX
if [ - z "$PREFIX" ]; then 
    echo "Invalid Prefix Argument"
    exit 1
fi 
for file in "$DIRECTORY"/*; do 
 if [ -f "$file" ]; then 
 #RENAMING FILES USE BASENAME IS THE BEST PRACTICE.
    FILE_BASENAME= $(basename "$file")
    mv "$file" "$DIRECTORY/$PREFIX$FILE_BASENAME 
    echo "Renamed $file to $PREFIX$FILE_BASENAME"
 fi 
done
