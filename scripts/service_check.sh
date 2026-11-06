
#!/bin/bash

set -Eeuo pipefail

# Load configuration
source "$HOME/linux-server-management/config/settings.conf"

# Create log directory
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/service_monitor.log"

# Services to monitor
SERVICES=("nginx" "sshd" "crond")

echo "=================================="
echo "     LINUX SERVICE MONITORING"
echo "=================================="

echo "Date: $(date)"
echo

# Check each service
for SERVICE in "${SERVICES[@]}"
do
    if systemctl is-active --quiet "$SERVICE"; then
        STATUS="ACTIVE"
        echo "$SERVICE : ACTIVE"
    else
        STATUS="NOT ACTIVE"
        echo "WARNING: $SERVICE is NOT ACTIVE"
    fi

    # Save results in log file
    {
        echo "Date: $(date)"
        echo "Service: $SERVICE"
        echo "Status: $STATUS"
        echo "------------------------------"
    } >> "$LOG_FILE"

done

echo
echo "Service monitoring completed."
echo "Results saved to $LOG_FILE"
echo "=================================="
