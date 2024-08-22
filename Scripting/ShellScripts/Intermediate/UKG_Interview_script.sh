#!/bin/bash

# Instances to connect to
instances=(instance1 instance2 instance3 instance4 instance5 instance6)

# Private key for SSH authentication
PRIVATE_KEY="$HOME/.ssh/id_rsa"
REMOTE_LOG_FILE="/var/log/instance.log"  # Adjust this path as needed
HOSTNAME_FILE="$HOME/hostname.txt"
IP_TO_FIND="192.168.0.1"
> "$HOSTNAME_FILE"
for instance in "${instances[@]}"; do
    echo "Connecting to ${instance}..."

    ssh -i "$PRIVATE_KEY" "$instance" <<EOF
        echo "Connected to ${instance}"
        if grep -iq "$IP_TO_FIND" "$REMOTE_LOG_FILE"; then
            echo "${instance} has $IP_TO_FIND in its log file" >> "$HOSTNAME_FILE"
        else
            echo "${instance} does not have $IP_TO_FIND in its log file" >> "$HOSTNAME_FILE"
        fi
        echo "Disconnected from ${instance}"
EOF

echo "" >> "$HOSTNAME_FILE"
done
