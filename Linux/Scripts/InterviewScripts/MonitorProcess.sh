
while true; do 
sleep 240
PROCESS_STATUS=$(ps -ef | grep -iq java; echo $?)
if [ $PROCESS_STATUS -gt 0]; then 
    echo "Process is running" >> /dev/null
else 
    sudo systemctl start java
    echo "Java Process started" |  mail -s "Process Restarted" tanujarora2703
fi 
done 
