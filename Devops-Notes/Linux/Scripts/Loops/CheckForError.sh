#!/bin/bash
SERVERS=("instance1","instance2","instance3")
PEM_KEY="/home/.ssh/key.pem"
USER="root"
LOG_LOCATION="/var/log/ssh_logs"
ACCESSIBLE_SERVER= "/var/log/servers"
for server in "${SERVERS[@]}"; do
    ssh -i $PEM_KEY $USER@$server << EOF
    TOTAL_PORTS=netstat -an | grep -iq ":22 .*LISTEN" | wc -l 
    if [ "$TOTAL_PORTS" -eq 0 ]; then
        echo "SSH is enabled for $server"
    fi
EOF
 if [ $? -eq 0 ]; then
        echo "SSH is enabled for $server" >> $LOG_LOCATION
        echo "$server" >> $ACCESSIBLE_SERVER
    fi
done
