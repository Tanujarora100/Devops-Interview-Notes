read -p "Enter the URL File" $FILE 
if [ ! -f "$FILE" ]; then
    echo "File not found"
    exit 1
fi 
echo "Processing URLs from $FILE"

# Use a while loop to read each line from the file
while IFS= read -r URL; do