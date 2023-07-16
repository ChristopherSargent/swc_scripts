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

# Add date time stamp to root and jboss prompts/history's
echo "export PROMPT_COMMAND='echo -n \[\$(date +%F-%T)\]\ '" >> /etc/bashrc && echo "export HISTTIMEFORMAT='%F-%T '" >> /etc/bashrc && source /etc/bashrc

# Add ll alias 
echo "alias ll='ls -alF'" >> /etc/bashrc && source /etc/bashrc
```
3. chmod 700 datetime.sh
4. ./datetime.sh
