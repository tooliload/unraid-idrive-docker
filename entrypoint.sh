#!/bin/sh
# Entrypoint for idrive
echo "iDrive start.."

echo "Update iDrive Deps"
/work/IDriveForLinux/scripts/account_setting.pl true

echo "Checking for updates to iDrive perl scripts"
/work/IDriveForLinux/scripts/check_for_update.pl silent



# Docker Logs
tail -f /var/log/idrive.log

# Run Backupscript
/work/IDriveForLinux/scripts/Backup_Script.pl &
