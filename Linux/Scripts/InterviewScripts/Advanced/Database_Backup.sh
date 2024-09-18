#!/bin/bash
BACKUP_DIRECTORY="/var/working/backup"
CURRENT_DATE=$(date +%Y-%m-%d_%H-%M-%S)
mkdir -p "$BACKUP_DIRECTORY"
DATABASE_USER="root"
DATABASE_PASSWORD="your_database_password"
DATABASE_NAME="your_database_name"

mysqldump -u "$DATABASE_USER" -p"$DATABASE_PASSWORD"  > "$BACKUP_DIRECTORY/${DATABASE_NAME}_$CURRENT_DATE.sql"

if [ $? -eq 0 ]; then 
    echo "$DATABASE_NAME Backup"
    echo "--------------------------"
    echo "Backup completed successfully at $(date)"
    echo "Backup file: $BACKUP_DIRECTORY/${DATABASE_NAME}_$CURRENT_DATE.sql"
    echo "--------------------------"
    exit 0
else
    echo "Error: Failed to backup $DATABASE_NAME"
    exit 1
fi