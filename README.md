# Automated Linux Server Management System

## Project Overview

The Automated Linux Server Management System is a Bash scripting project developed on AlmaLinux 10.2 to simplify and automate common Linux system administration tasks.

The project monitors system resources, performs automated backups, checks system services, monitors system logs, audits users and groups, and performs basic security checks.

## Technologies Used

- **Operating System:** AlmaLinux 10.2
- **Scripting:** Bash Shell Scripting
- **Service Management:** systemd
- **Task Scheduling:** Cron
- **Backup:** tar and gzip
- **Version Control:** Git and GitHub

## Project Features

### 1. System Monitoring
- Monitors CPU utilization.
- Checks memory usage.
- Monitors disk utilization.
- Generates alerts based on configured thresholds.
- Saves monitoring results in log files.

### 2. Automated Backup and Restoration
- Creates timestamped backup archives.
- Uses tar and gzip for compression.
- Verifies backup archives.
- Supports restoration of backed-up data.

### 3. Log Monitoring
- Collects error-level system logs using journalctl.
- Generates timestamped error reports.
- Stores reports for troubleshooting.

### 4. Service Monitoring
- Checks the status of important Linux services.
- Monitors Nginx, SSH and Cron services.
- Records service status in log files.

### 5. User and Group Auditing
- Lists system users and groups.
- Identifies users with interactive login shells.
- Checks administrative group membership.
- Generates audit reports.

### 6. Security Auditing
- Checks SELinux status.
- Checks firewall service status.
- Verifies SSH service status and root login configuration.
- Identifies failed system services.

### 7. Cron Automation
Uses cron jobs to schedule administrative tasks automatically.

| Task | Schedule |
|---|---|
| System monitoring | Every 5 minutes |
| Service monitoring | Every 5 minutes |
| Log monitoring | Every hour |
| Automated backup | Daily at 2:00 AM |
| User auditing | Daily at 2:30 AM |

## Project Directory Structure

```text
linux-server-management/
├── backups/
├── config/
│   └── settings.conf
├── data/
│   └── company/
├── logs/
├── reports/
└── scripts/
    ├── backup.sh
    ├── log_monitor.sh
    ├── monitor.sh
    ├── security_audit.sh
    ├── service_check.sh
    └── user_audit.sh
```

## How to Run the Project

### Step 1: Clone the repository

```bash
git clone git@github.com:anupama-github123/automated-linux-server-management.git
```

### Step 2: Navigate to the project directory

```bash
cd automated-linux-server-management
```

### Step 3: Give execution permissions

```bash
chmod +x scripts/*.sh
```

### Step 4: Run the scripts

```bash
./scripts/monitor.sh
./scripts/backup.sh
./scripts/log_monitor.sh
./scripts/service_check.sh
./scripts/user_audit.sh
./scripts/security_audit.sh
```

Some operations may require sudo privileges.

## Learning Outcomes

- Practical experience with Linux system administration.
- Improved Bash scripting skills.
- Understanding of system monitoring and log management.
- Hands-on experience with backup and restoration.
- Experience with cron-based task automation.
- Understanding of Linux services and security auditing.
- Hands-on experience with Git and GitHub.

