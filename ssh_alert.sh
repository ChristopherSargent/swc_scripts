#!/bin/sh

# Your Email Information: Recipient (To:), Subject and Body
RECIPIENT="use@email.com"
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
