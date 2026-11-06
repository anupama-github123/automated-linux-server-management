
#!/bin/bash

# Stop if an unexpected error occurs
set -Eeuo pipefail

# Load project configuration
source "$HOME/linux-server-management/config/settings.conf"

# Create log directory
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/monitor.log"

echo "=================================="
echo "      LINUX SERVER MONITORING"
echo "=================================="

echo "Date: $(date)"
echo

# CPU Monitoring
read cpu user nice system idle iowait irq softirq steal rest < /proc/stat

IDLE1=$((idle + iowait))
TOTAL1=$((user + nice + system + idle + iowait + irq + softirq + steal))

sleep 1

read cpu user nice system idle iowait irq softirq steal rest < /proc/stat

IDLE2=$((idle + iowait))
TOTAL2=$((user + nice + system + idle + iowait + irq + softirq + steal))

CPU_USAGE=$(awk -v i1="$IDLE1" -v i2="$IDLE2" \
-v t1="$TOTAL1" -v t2="$TOTAL2" \
'BEGIN {
    if (t2 == t1) print 0
    else printf "%.2f", (1-(i2-i1)/(t2-t1))*100
}')

# Memory Monitoring
MEMORY_USAGE=$(free | awk '/Mem:/ {
    printf "%.2f", ($2-$7)/$2*100
}')

# Disk Monitoring
DISK_USAGE=$(df -P / | awk 'NR==2 {
    gsub("%","",$5)
    print $5
}')

echo "CPU USAGE: $CPU_USAGE%"
echo "MEMORY USAGE: $MEMORY_USAGE%"
echo "DISK USAGE: $DISK_USAGE%"

echo
echo "========== ALERTS =========="

# CPU Alert
if awk -v u="$CPU_USAGE" -v l="$CPU_THRESHOLD" \
'BEGIN {exit !(u > l)}'; then
    echo "WARNING: High CPU usage!"
fi

# Memory Alert
if awk -v u="$MEMORY_USAGE" -v l="$MEMORY_THRESHOLD" \
'BEGIN {exit !(u > l)}'; then
    echo "WARNING: High memory usage!"
fi

# Disk Alert
if (( DISK_USAGE > DISK_THRESHOLD )); then
    echo "WARNING: High disk usage!"
fi

echo
echo "Monitoring completed."

# Save results in log file
{
    echo "Date: $(date)"
    echo "CPU: $CPU_USAGE%"
    echo "Memory: $MEMORY_USAGE%"
    echo "Disk: $DISK_USAGE%"
    echo "------------------------------"
} >> "$LOG_FILE"

echo "Results saved to $LOG_FILE"
