#!/bin/bash
DIRECTORY="/var/log"
if [ ! -d "$DIRECTORY" ]; then
    echo " Directory does not exist"
    exit 1
fi 
declare -A filemap
for file in "$DIRECTORY"/*;do 
    if [ -f "$file" ]; then
    file_size=$( stat -c%s "$file")
    name= $(basename "$file")
    keyname="$name:$file_size"
    filemap["$keyname"]+="$file"
    fi
done
for key in "${!file_map[@]}"; do
 if [[ $(echo "${file_map[$key]}" | wc -w) -gt 1 ]]; then
    echo "Duplicate file(s) found for key: $key"
    echo "${file_map[$key]}"
fi
done 

