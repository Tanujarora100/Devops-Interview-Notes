
!/bin/bash
#AUTHOR: TANUJ ARORA
#DATE: 30th July 2024

SERVERS=(webserver1 webserver2)
SSH_KEY_PATH="/home/$USER/.ssh/id_rsa"
LOG_FILE_PATH="/var/log/weblogic.log"
FINAL_HOSTS="/users/tanujarora/downloads/final_hosts.txt"

for server in "${SERVERS[@]}"; do
    echo "--------$(date +%Y-%m-%d)"
    echo " Connecting to the $server ....."
    echo " ---------------------------"
    ssh -i "$SSH_KEY_PATH" "$USER@$server" << EOF
    sudo apt-get update && sudo apt-get upgrade -y
    output=$(grep -Eiqo "([0-9]{1,3}\.){3}[0-9]{1,3}" "$LOG_FILE_PATH" | wc -l)
    if [ "$output" -gt 1 ]; then 
        echo "Server: $server IP address found in the log file" >> "$FINAL_HOSTS"
    fi
EOF
    echo " ---------------------------"
    echo " "
done
