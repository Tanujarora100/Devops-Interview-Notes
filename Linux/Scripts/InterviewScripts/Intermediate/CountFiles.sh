read -p "Enter the directory where you want to count files" DIRECTORY
if [ ! -d "$DIRECTORY" ]; then 
    echo "Invalid directory"
    exit 1
fi 
TOTAL_FILES=$(find "$DIRECTORY" -type f | wc -l)
echo "Total number of files in $DIRECTORY: $TOTAL_FILES"