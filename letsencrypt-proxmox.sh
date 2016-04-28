#!/bin/bash

# set $hostname equal to FQDN
host_name=$(hostname -f)

# set months for renewal
this_month=`date +'%^b'`
renew_one=`date +'%^b' -d '+3 month'`
renew_two=`date +'%^b' -d '+6 month'`
renew_three=`date +'%^b' -d '+9 month'`

# ask for user's email address for LetsEncrypt registration
echo -e "Please enter your contact email address:\n"
read email

# make sure git is installed
apt-get install git

# clone letsencrypt
git clone https://github.com/letsencrypt/letsencrypt /

# make sure script works even if port 80 is currently bound
sed -i '/ \"\"\"$/a \\n\ \ \ \ return False\n' /letsencrypt/certbot/plugins/util.py

# generate LetsEncrypt certs
/letsencrypt/letsencrypt-auto certonly --standalone --standalone-supported-challenges http-01 -d $host_name --agree-tos --email=$email

# back up existing Proxmox certs
mv /etc/pve/pve-root-ca.pem /etc/pve/pve-root-ca.pem.orig
mv /etc/pve/local/pve-ssl.key /etc/pve/local/pve-ssl.key.orig
mv /etc/pve/local/pve-ssl.pem /etc/pve/local/pve-ssl.pem.orig

# install new LetsEncrypt certs
cp /etc/letsencrypt/live/$host_name/chain.pem /etc/pve/pve-root-ca.pem
cp /etc/letsencrypt/live/$host_name/privkey.pem /etc/pve/local/pve-ssl.key
cp /etc/letsencrypt/live/$host_name/cert.pem /etc/pve/local/pve-ssl.pem

# restart Proxmox VE
service pveproxy restart
service pvedaemon restart

# add LetsEncrypt renewal cron job
$(crontab -l; echo "0 0 1 $this_month,$renew_one,$renew_two,$renew_three * /letsencrypt/letsencrypt-auto renew --agree-tos --email=$email") | crontab -
