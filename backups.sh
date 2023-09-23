#!/bin/bash
# back up server christopher.sargent@sargentwalker.io 09232023
# Backup Windows NUC via WSL
# mkdir -p /root/backups/logs && mkdir -p /root/backups/scripts and copy backups.sh to /root/backups/scripts and execute from cron via 20 09 * * * /root/backups/scripts/backups.sh &>/dev/null &

log_path="/root/backups/logs/backup_$(date +%Y-%m-%d).log"
copyfrom="/mnt/c/Users/cas/"
copyto="cas@172.18.0.120:/media/cas/Movies-14TB/NUC01_Backup/cas"
rsync -avP --exclude={"Application Data","Cookies","Local Settings","My Documents","NetHood","NTUSER.DAT*","ntuser.ini","PrintHood","Recent","SendTo","Start Menu","Templates"} $copyfrom $copyto &>>$log_path
