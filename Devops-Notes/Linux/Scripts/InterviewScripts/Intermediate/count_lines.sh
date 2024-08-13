#!/bin/bash 
if [ -z "$1" ]; then 
    echo "No filename provided"
    exit 1
fi 
# PROVIDED FILE CAN BE AN ARRAY ALSO.
for FILE_TYPE in "${@}" ; do
if [ -f "$FILE_TYPE" ]; then
    TOTAL_LINES=$(wc -l < "$FILE_TYPE" )
    echo "Total lines in the file: $TOTAL_LINES"
elif [ -d "$FILE_TYPE" ]; then
    echo "Directory provided and not a file"
else
    echo "File or directory not found"
fi
done 
#END OF SCRIPT