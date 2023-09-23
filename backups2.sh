#!/bin/bash
# back up server christopher.sargent@sargentwalker.io 09232023
# backup NUC WSL home directory
# mkdir -p /root/backups/logs && mkdir -p /root/backups/scripts and copy backups.sh to /root/backups/scripts and execute from cron

log_path="/root/backups/logs/backup2_$(date +%Y-%m-%d).log"
copyfrom="/home/"
copyto="cas@172.18.0.120:/media/cas/Movies-14TB/NUC01_Backup/root"
rsync -avP $copyfrom $copyto &>>$log_path
