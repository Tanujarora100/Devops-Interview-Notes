#!/bin/bash
read -p "Enter the number " NUMBER
if [ -z "$NUMBER" ]; then
    echo "Please enter a number"
    exit 1
fi 
if(( "$NUMBER" % 2 ==0  )); then 
 echo "The number is even"
else 
 echo "The number is odd"
fi 