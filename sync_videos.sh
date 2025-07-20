#!/bin/bash

set -e
set -x

SOURCE_DIR="/home/Shinobi/videos"
DEST_USER="Mayank"
DEST_IP="192.168.1.11"

# Corresponds to the RpiBackups directory on larger HDD
DEST_PATH="/d/RPi_Backups"
LOG_FILE="/home/msharmapi/sync_log.txt"

date
/usr/bin/rsync -av --ignore-errors -e ssh "$SOURCE_DIR" "${DEST_USER}@${DEST_IP}:${DEST_PATH}" >> "$LOG_FILE" 2>&1

