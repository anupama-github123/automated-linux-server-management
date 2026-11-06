
#!/bin/bash

set -Eeuo pipefail

# Load configuration
source "$HOME/linux-server-management/config/settings.conf"

# Create report directory
mkdir -p "$REPORT_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT_FILE="$REPORT_DIR/user-audit-$TIMESTAMP.log"

echo "===================================="
echo "       LINUX USER AUDIT SYSTEM"
echo "===================================="

{
    echo "LINUX USER AND GROUP AUDIT"
    echo "Date: $(date)"
    echo

    echo "========== NORMAL USERS =========="

    getent passwd | awk -F: '
    $3 >= 1000 && $3 < 65534 {
        printf "Username: %-15s UID: %-8s Home: %-20s Shell: %s\n", $1, $3, $6, $7
    }'

    echo
    echo "========== GROUPS =========="

    getent group | while IFS=: read -r group password gid members
    do
        echo "Group: $group | GID: $gid | Members: $members"
    done

    echo
    echo "========== ADMIN USERS =========="

    if getent group wheel >/dev/null; then
        getent group wheel
    else
        echo "Wheel group not found"
    fi

    echo
    echo "========== INTERACTIVE LOGIN USERS =========="

    getent passwd | awk -F: '
    $3 >= 1000 && $3 < 65534 &&
    $7 !~ /(nologin|false)$/ {
        print $1 " : " $7
    }'

    echo
    echo "========== AUDIT COMPLETED =========="

} | tee "$REPORT_FILE"

echo
echo "Audit report saved to: $REPORT_FILE"
