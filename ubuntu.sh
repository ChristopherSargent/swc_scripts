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
