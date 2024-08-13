#!/bin/bash

HOSTS=(
    "host1.example.com"
    "host2.example.com"
    "host3.example.com"
)

for host in "${HOSTS[@]}"; do
    if ! ping -c 1 "$host" &> /dev/null; then
        echo "Host $host is unreachable."
    fi
done