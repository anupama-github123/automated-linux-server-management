
#!/bin/bash

set -Eeuo pipefail

# Load configuration
source "$HOME/linux-server-management/config/settings.conf"

# Create required directories
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# Define backup source
SOURCE_DIR="$DATA_DIR/company"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Backup filename
BACKUP_FILE="$BACKUP_DIR/company-backup-$TIMESTAMP.tar.gz"

# Log file
LOG_FILE="$LOG_DIR/backup.log"

echo "===== AUTOMATED BACKUP SYSTEM ====="
echo "Backup started: $(date)"

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found" | tee -a "$LOG_FILE"
    exit 1
fi

# Create backup
if tar -czf "$BACKUP_FILE" -C "$DATA_DIR" company; then

    # Verify backup archive
    if tar -tzf "$BACKUP_FILE" > /dev/null; then
        echo "SUCCESS: Backup created"
        echo "Location: $BACKUP_FILE"

        {
            echo "Date: $(date)"
            echo "Status: SUCCESS"
            echo "File: $BACKUP_FILE"
            echo "--------------------------"
        } >> "$LOG_FILE"
    else
        echo "ERROR: Backup verification failed" | tee -a "$LOG_FILE"
        rm -f "$BACKUP_FILE"
        exit 1
    fi
else
    echo "ERROR: Backup creation failed" | tee -a "$LOG_FILE"
    rm -f "$BACKUP_FILE"
    exit 1
fi

echo "Backup completed."
