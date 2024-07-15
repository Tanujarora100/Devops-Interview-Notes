#!/bin/bash
LOAD=$(uptime | awk -F 'load average:' '{ print $1 $2 $3 }')
echo "$(date +%Y-%m-%d): Load average is $CURRENT_AVERAGE"
