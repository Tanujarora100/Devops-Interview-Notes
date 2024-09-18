#!/bin/bash
DIRECTORY="/var/log"
find "$DIRECTORY" -type f -name "*.log" -mtime +30 -delete