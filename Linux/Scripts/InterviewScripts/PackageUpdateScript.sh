#!/bin/bash 
SERVERS=(webserver1 webserver2 webserver3 webserver4 webserver5)
SSH_KEY_PATH="$HOME/$USER/.ssh/id_rsa"
for server in "${SERVERS[@]}"; do 
    echo " Connecting to the $server ....."
    ssh -i "$SSH_KEY_PATH"  "$USER@$server"
    echo "---------------------------" EOF<< 
        sudo apt-get update && sudo apt upgrade -y 
        sudo apt install -y nginx 
        sudo apt install docker.io -y 
        sudo apt install docker-compose -y
        sudo usermod -aG docker $USER 
        sudo chmod 666 /var/run/docker.sock
        sudo systemctl start docker
        sudo systemctl enable docker
    EOF 
    echo "---------------------------"
    echo "Completed on $server ....."
    echo "---------------------------"
done