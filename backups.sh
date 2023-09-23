#!/bin/bash
# back up server christopher.sargent@sargentwalker.io 09232023
# mkdir -p /root/backup_admin/logs && mkdir -p /root/backup_admin/scripts and copy backups.sh to /root/backup_admin/scripts and execute from cron 

log_path="/root/backup_admin/logs/backup_$(date +%Y-%m-%d).log"
copyfrom=""
copyto=""
rsync -avP --exclude={"/dev/","/proc/","/sys/","/tmp/","/run/","/media/","/mnt/*","/lost+found","/$copyfrom/*"} / $copyto &>>$log_path

