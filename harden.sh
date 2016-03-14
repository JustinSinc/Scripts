#!/bin/bash
ssh-copy-id $1
scp ~/ansible/configs/sshd_config $1:~/sshd_config
ssh -t $1 "sudo mv ~/sshd_config /etc/sshd_config && sudo /bin/rm -v /etc/ssh/ssh_host_* && sudo dpkg-reconfigure openssh-server && echo 'sshd: 192.184.82.89' | sudo tee /etc/hosts.allow && echo 'ALL:ALL' | sudo tee /etc/hosts.deny"
ssh-keygen -f "/home/sinc/.ssh/known_hosts" -R $1
