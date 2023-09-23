#!/bin/bash
# back up server christopher.sargent@sargentwalker.io 09232023
# backup NUC WSL root directory
# mkdir -p /root/backups/logs && mkdir -p /root/backups/scripts and copy backups.sh to /root/backups/scripts and execute from cron

log_path="/root/backups/logs/backup1_$(date +%Y-%m-%d).log"
copyfrom="/root/"
copyto="cas@172.18.0.120:/media/cas/Movies-14TB/NUC01_Backup/root"
rsync -avP $copyfrom $copyto &>>$log_path
