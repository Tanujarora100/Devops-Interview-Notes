#!/bin/bash

arr=(24 27 84 11 99)
echo "Given array: ${arr[*]}"
smallest=${arr[0]}
largest=${arr[0]}

for num in "${arr[@]}"
do
    if [ $num -lt $smallest ]; then
        smallest=$num
    fi
    if [ $num -gt $largest ]; then
        largest=$num
    fi
done

echo "The smallest element: $smallest"
echo "The largest element: $largest"