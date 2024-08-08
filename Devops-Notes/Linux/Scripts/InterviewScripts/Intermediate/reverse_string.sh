#!/bin/bash 
read -p "Enter the string" STRING_INPUT
if [ -z "$STRING_INPUT" ]; then
    echo "Error: Input string cannot be empty."
    exit 1
fi
REVERSED_STRING=""
for((i=${STRING_INPUT}-1;i>=0;i--)); do 
REVERSED_STRING+="${STRING_INPUT:$i:1}"
done 
echo "Reversed string: $REVERSED_STRING"