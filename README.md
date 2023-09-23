![alt text](swclogo.jpg)
# swc_scripts
This repository contains various scripts. For additional details, please email at [christopher.sargent@sargentwalker.io](mailto:christopher.sargent@sargentwalker.io).

# Configure email alerts for ssh login
1. ssh cas@172.18.0.193
2. sudo -i
3. apt install sendmail -y 
4. systemctl enable sendmail && systemctl start sendmail
5. cp /etc/mail/sendmail.cf /etc/mail/sendmail.cf.ORIG
6. sed -i -e 's|DMlocalhost.localdomain|DMlocalhost.localdomain|g' /etc/mail/sendmail.cf
7. echo "Subject: test 3" | sudo sendmail -v user@email.com
* note this is a test 
8. mkdir /etc/pam.scripts && chmod 0755 /etc/pam.scripts && touch /etc/pam.scripts/ssh_alert.sh
9. chmod 0700 /etc/pam.scripts/ssh_alert.sh && chown root:root /etc/pam.scripts/ssh_alert.sh && vi /etc/pam.scripts/ssh_alert.sh 
* note1 type :set paste and then i for insert if having issues pasting in vim (format wise).
* note2 change RECIPIENT to the email address you want to receiver the alert on.
```
#!/bin/sh

# Your Email Information: Recipient (To:), Subject and Body
RECIPIENT="user@email.com"
SUBJECT="Email from your Server: SSH Login Alert"

BODY="
An SSH login was successful. Details below:
        User:        $PAM_USER
        User IP Host: $PAM_RHOST
        Service:     $PAM_SERVICE
        TTY:         $PAM_TTY
        Date:        `date`
        Server:      `uname -a`
"

if [ ${PAM_TYPE} = "open_session" ]; then
        echo "Subject:${SUBJECT} ${BODY}" | /usr/sbin/sendmail ${RECIPIENT}
fi

exit 0
```
10. cp /etc/pam.d/sshd /etc/pam.d/sshd.ORIG 
11. echo '# SSH Alert script
session required pam_exec.so /etc/pam.scripts/ssh_alert.sh' >> /etc/pam.d/sshd

12.Now when someone sshs in you get an email like this 
* note From should be the hostname of the server that was accessed
```
From = cas@casdev01.cas.local
To = Undisclosed 
Body =
An SSH login was successful. Details below:
  	User:        cas
	User IP Host: 172.18.0.143
	Service:     sshd
	TTY:         ssh
	Date:        Sun Jul 16 03:57:17 PM UTC 2023
	Server:      Linux casdev01.cas.local 5.15.0-76-generic #83-Ubuntu SMP Thu Jun 15 19:16:32 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

```
# Date time in terminal and history
1. mkdir /root/scripts && cd /root/scripts
2. vim datetime.sh
```
#!/bin/bash
# Christopher Sargent 05312023
set -x #echo on

# Add date time stamp to /etc/bashrc for all users prompts/history's
echo "export PROMPT_COMMAND='echo -n \[\$(date +%F-%T)\]\ '" >> /etc/bashrc && echo "export HISTTIMEFORMAT='%F-%T '" >> /etc/bashrc && source /etc/bashrc

# Add ll alias
echo "alias ll='ls -alF'" >> /etc/bashrc && source /etc/bashrc
```
3. chmod 700 datetime.sh
4. ./datetime.sh
# Ubuntu.sh is used by my ansible role ubuntu_stack 
1. mkdir /root/scripts && cd /root/scripts 
2. vim ubuntu.sh
```
#!/bin/bash
# Ubuntu 22.04 bmax script christopher.sargent@sargentwalker.io 03162023 updated 04082023
set -x #echo on

# Update
apt update && apt upgrade -y

# Install chrome 
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install ./google-chrome-stable_current_amd64.deb -y

# Backup .bashrc
cp /root/.bashrc /root/.bashrc.ORIG && cp /home/cas/.bashrc /home/cas/.bashrc.ORIG && cp /home/jdm/.bashrc /home/jdm/.bashrc.ORIG

# Fix HISTSIZE and HISTFILESIZE
sed -i -e 's|HISTSIZE=1000|HISTSIZE=100000|g' /root/.bashrc && sed -i -e 's|HISTSIZE=1000|HISTSIZE=100000|g' /home/jdm/.bashrc && sed -i -e 's|HISTSIZE=1000|HISTSIZE=100000|g' /home/cas/.bashrc
sed -i -e 's|HISTFILESIZE=2000|HISTFILESIZE=200000|g' /root/.bashrc && sed -i -e 's|HISTFILESIZE=2000|HISTFILESIZE=200000|g' /home/jdm/.bashrc && sed -i -e 's|HISTFILESIZE=2000|HISTFILESIZE=200000|g' /home/cas/.bashrc

# Timestamps to history and prompts
echo "export PROMPT_COMMAND='echo -n \[\$(date +%F-%T)\]\ '" >> /root/.bashrc && echo "export HISTTIMEFORMAT='%F-%T '" >> /root/.bashrc && source /root/.bashrc
echo "export PROMPT_COMMAND='echo -n \[\$(date +%F-%T)\]\ '" >> /home/cas/.bashrc && echo "export HISTTIMEFORMAT='%F-%T '" >> /home/cas/.bashrc && source /home/cas/.bashrc
echo "export PROMPT_COMMAND='echo -n \[\$(date +%F-%T)\]\ '" >> /home/jdm/.bashrc && echo "export HISTTIMEFORMAT='%F-%T '" >> /home/jdm/.bashrc && source /home/jdm/.bashrc

# Configure KVM
systemctl stop libvirtd && cd /etc/apparmor.d/disable/ && rm -rf usr.sbin.libvirtd && cp /etc/libvirt/qemu.conf /etc/libvirt/qemu.conf.ORIG
sed -i -e 's|#user = "root"|user = "jdm"|g' /etc/libvirt/qemu.conf  && sed -i -e 's|#group = "root"|group= "libvirt-qemu"|g' /etc/libvirt/qemu.conf && systemctl restart libvirtd
chown -R libvirt-qemu:libvirt-qemu /var/lib/libvirt/images/

# Docker install
apt -y install ansible apt-transport-https ca-certificates curl gnupg-agent software-properties-common vim powertop
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && cd /etc/apt/ && mv trusted.gpg trusted.gpg.d/
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
apt update && apt install docker-ce docker-ce-cli containerd.io -y 

# Docker compose install
curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose 
```
3. chmod 700 ubuntu.sh
4. ./ubuntu.sh
# pwnedpasswords.sh
* ./pwnedpasswords.sh PasswordThatYouWantToCheck 
1. ./pwnedpasswords.sh doolittle
```
Candidate password: doolittle
3D0D3E36E1151D7A6669B58DD3170342C28:3068
Candidate password is compromised
```
# bakups.sh
* Backup script to back up Windows via WSL to a linux mounted backup server
1. git clone https://github.com/ChristopherSargent/swc_scripts.git
2. mkdir -p /root/backups/logs && mkdir -p /root/backups/scripts
3. cp swc_scripts/backups* /root/backups/scripts
4. update copyto and copyfrom and adjust excludes as needed
5. crontab -e
```
20 09 * * * /root/backups/scripts/backups.sh &>/dev/null &
10 10 * * * /root/backups/scripts/backups1.sh &>/dev/null &
15 10 * * * /root/backups/scripts/backups2.sh &>/dev/null &
```
6. systemctl restart cron
7. verify backups
