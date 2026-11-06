
#!/bin/bash

set -Eeuo pipefail

# Load project configuration
source "$HOME/linux-server-management/config/settings.conf"

# Create required directories
mkdir -p "$LOG_DIR" "$REPORT_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Report filename
REPORT_FILE="$REPORT_DIR/error-report-$TIMESTAMP.log"

# Project log file
LOG_FILE="$LOG_DIR/log_monitor.log"

echo "=================================="
echo "     LINUX LOG MONITORING"
echo "=================================="

echo "Date: $(date)"
echo "Checking system errors..."
echo

# Collect error-level system logs
if journalctl -p err --since "24 hours ago" \
--no-pager > "$REPORT_FILE"; then

    # Count error messages
    ERROR_COUNT=$(wc -l < "$REPORT_FILE")

    echo "Log analysis completed."
    echo "Errors found: $ERROR_COUNT"

    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo
        echo "WARNING: System errors detected!"
        echo "Check report: $REPORT_FILE"
    else
        echo "No error-level messages found."
    fi

    # Save execution details
    {
        echo "Date: $(date)"
        echo "Errors found: $ERROR_COUNT"
        echo "Report: $REPORT_FILE"
        echo "------------------------------"
    } >> "$LOG_FILE"

else
    echo "ERROR: Unable to read system journal."
    echo "Check journal permissions."
    exit 1
fi

echo
echo "Report saved successfully."
echo "=================================="
