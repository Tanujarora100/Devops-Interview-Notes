#!/bin/bash 
echo "Current User Logged in is : $USER"
echo "Current kernel version is $(uname -a)" 
echo "Current shell is $SHELL"
echo "Current date and time is $(date)"
echo "Total memory in the system is $(df -h  | awk '{print $4}' 
echo "Disk usage in root directory is $(du -sh / | awk '{print $1}')

"$USER" ==> Correct
 