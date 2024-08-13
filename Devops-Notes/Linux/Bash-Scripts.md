# BACKUP SCRIPT
```bash
BACKUP_DIR= /path/to/backup
CURRENT_DIR= /path/to/current
TIMESTAMP= $(date +%Y-%m-%d)
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/backup-$TIMESTAMP.tar.gz -C $CURRENT_DIR 
echo " BACKUP COMPLETED"
<<<<<<< HEAD
```
=======
if[ $? eq 0]; then
    echo " Backup Succeeded!!!!!"
else
    echo " Backup Failed"
```
----------------------------------------
## SCRIPT TO TAKE INPUT
```bash
#!/bin/bash

echo  "What is your name"

read -p "Enter name " name

echo " Hello, $name! Nice to meet you"
```
----------------------------------
### SCRIPT TO CHECK IF FILE EXISTS
```bash
#!/bin/bash
echo"What is your filename"
read file
if [ -z "$file"]; then
    echo " No File Name Was given "
    exit 1
fi

find . -type f -name "$file"
```
--------------------------------------------

# LAST MODIFIED IN 7 Days
```sh
echo " Enter the directory you want to search "
read directory
if [ -z directory ]; then
 echo " Directory Not given exiting........"
 exit 1
fi
find "$directory" -type d -mtime -7
```
------------------------------------------------

# DELETE EMPTY FILES
```bash
if[ ! -f /path/file.txt ] || [ -s path/file.txt]; then
 echo " File is Not empty Or File Does Not Exist"
else
    rm -r path/file.txt
    echo " Empty Files deleted "
fi
```
----------------------------------------

# DELETE FILES IN A SPECIFIC DIRECTORY
```bash
read -p "Enter Directory" directory
if [! -d directory] ||[ -z directory]; then
    echo " Directory name is not given! exiting ......"
else
    find "$directory" -type f -empty -delete
```
----------------------------------------------------

### SCRIPT TO GET THE FILES GREATER THAN A SIZE
```bash
echo "Enter a directory name"
read directory
echo " Enter the maximum file size"
read -s filesize
if[ -z "$directory"] || [ -z "$filesize"]; then
    echo " Directory name is not given! exiting ......"
else
    find "$directory" -type f -size +"$filesize"
```
-------------------------------------------------------
# SCRIPT TO DELETE THE TEMP FILES
```bash
echo "Enter the directory name "
read directory
if [ -z "$directory"] || [  -d "$directory"]; then
    echo " Issue with directory given ! EXITING!!!!!!! "
else
    find "$directory" -type f - name "*.tmp" -delete
    echo "Files with extension $extension in $directory have been deleted.
```
-------------------------------------------------------

# LOG ANALYSIS SCRIPT

```bash
count_error_msg() {
local file_name ="$1"
if [-f "$file-name"]; then

local error_count= $(grep -c -i "ERROR" "$FILE_NAME")

echo "Total Number of error messages in file $FILE_NAME: $error_count"

else

                echo " File is empty or does not exist"

                exit 1

fi

summarize_logs() {
local file_name= "$1"
if [-f "$file_name"]; then
echo " Summary of logs entries by date"
awk '{print $1}' "$file_name" | sort| uniq -c

else

    echo " Error File does not exist "

    exit 1

fi
```
---------------------------------------------------------------

# SCRIPT TO LIST FILES IN DIRECTORY
```bash
echo " Enter the directory "
read directory
if [ ! -d directory ] || [ -z directory]; then
    echo " Error with directory specified"
    exit 1
else
    ls -l "$directory"/
```
-----------------------------------------------------------

# UPDATE THE SYSTEMS
```bash
if [$(uname -s)"=='Linux" ]; then
 if [ -f /etc/debian_version]; then
        sudo apt update && sudo apt upgrade -y
elif [ -f /etc/redhat-release]; then
 sudo yum update && sudo yum upgrade -y
else
echo "Not supported "
fi
echo " Only for Linux Systems "
fi
```
-------------------------------------------

# ROTATE LOGS
```bash
LOG_DIRECTORY= "/var/log/app"
ROTATE_DIRECTORY="/var/backup/old/logs"
TIMESTAMP= $(date +%Y-%m-%d)
mkdir -p "$ROTATE_DIRECTORY"
find "$LOG_DIRECTORY" -type f -name "*.log" -exec mv {} "$ROTATE_DIRECTORY"/$TIMESTAMP"
echo "Logs rotated to $ROTATE_DIRECTORY"
```
----------------------------------------

# CHECK PROCESS IS RUNNING OR NOT
```bash
PROCESS_NAME ="nginx"
if pgrep '$PROCESS_NAME" > dev/null; then
echo " Running"
else
    echo "Not running"
```
---------------------------------------------------------------------

## SECOND WAY TO CHECK PROCESS RUNNING
```bash
count_process=$(ps -ef| grep -i "$PROCESS_NAME" | grep -v "grep"|  wc -l )
if [ count_process -eq 1 ]; then
 echo "Process running"
else
    echo "Not running"
>>>>>>> master
