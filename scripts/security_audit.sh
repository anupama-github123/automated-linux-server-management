
#!/bin/bash

set -uo pipefail

# Load project configuration
source "$HOME/linux-server-management/config/settings.conf"

# Create report directory
mkdir -p "$REPORT_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT_FILE="$REPORT_DIR/security-audit-$TIMESTAMP.log"

echo "===================================="
echo "       LINUX SECURITY AUDIT"
echo "===================================="

{
    echo "LINUX SERVER SECURITY REPORT"
    echo "Date: $(date)"
    echo

    # SELinux status
    echo "========== SELINUX STATUS =========="
    if command -v getenforce >/dev/null 2>&1; then
        getenforce
    else
        echo "SELinux utility not available"
    fi
    echo

    # Firewall status
    echo "========== FIREWALL STATUS =========="
    if systemctl is-active --quiet firewalld; then
        echo "Firewalld: ACTIVE"
    else
        echo "Firewalld: NOT ACTIVE"
    fi
    echo

    # SSH service
    echo "========== SSH SERVICE =========="
    if systemctl is-active --quiet sshd; then
        echo "SSH: ACTIVE"
    else
        echo "SSH: NOT ACTIVE"
    fi
    echo

    # SSH root login configuration
    echo "========== SSH ROOT LOGIN =========="
    if command -v sshd >/dev/null 2>&1; then
        sudo sshd -T 2>/dev/null |
        grep '^permitrootlogin ' ||
        echo "Unable to check SSH configuration"
    fi
    echo

    # Failed services
    echo "========== FAILED SERVICES =========="
    systemctl --failed --no-pager || true
    echo

    # Firewall rules
    echo "========== FIREWALL RULES =========="
    if command -v firewall-cmd >/dev/null 2>&1; then
        sudo firewall-cmd --list-all 2>&1 || true
    else
        echo "firewall-cmd is not installed"
    fi
    echo

    echo "========== SECURITY AUDIT COMPLETED =========="

} | tee "$REPORT_FILE"

echo
echo "Security report saved to:"
echo "$REPORT_FILE"
