# BACKUP SCRIPT
```bash
BACKUP_DIR= /path/to/backup
CURRENT_DIR= /path/to/current
TIMESTAMP= $(date +%Y-%m-%d)
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/backup-$TIMESTAMP.tar.gz -C $CURRENT_DIR 
echo " BACKUP COMPLETED"
```