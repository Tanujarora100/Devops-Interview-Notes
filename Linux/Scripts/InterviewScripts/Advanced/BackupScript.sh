read -p "Enter the source directory" SOURCE
read -p "Enter the destination directory" DEST
if [ ! -d "$DEST" ]; then 
   mkdir -p "$DEST"
fi

if [ ! -d "$SOURCE" ]; then 
    echo "Source directory not specified" 
    exit 1
fi 
TIMESTAMP=$(date "+%Y-%m-%dT%H:%M")
BACKUP_FILE= "$DEST"/backup_$TIMESTAMP.tar.gz"
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR"
# The tar command is used to create, extract, and manipulate tar (tape archive) files, which are commonly used for archiving and distributing multiple files and directories in Unix and Linux environments. The -czf and -C options are used frequently with tar.
# -C: Change to the specified directory before performing any operations.
# Explanation of tar -czf
# -c: Create a new archive.
# -z: Compress the archive using gzip.
# -f: Specify the filename of the archive.
