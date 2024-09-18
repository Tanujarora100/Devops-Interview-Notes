read -p "Enter the directory " DIRECTORY
if [ -z "$DIRECTORY" ]; then 
    echo "Invalid arguments" 
    exit 1
fi 
if [ ! -d "$DIRECTORY" ]; then 
    echo "Invalid directory"
    exit 1
fi 
TOTAL_SIZE=$(du -sh "$DIRECTORY" > /dev/null | awk '{ print $1}')
echo "Total size of directory '$DIRECTORY': $TOTAL_SIZE"