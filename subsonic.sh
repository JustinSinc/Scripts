#!/bin/bash
# A script for automating setup of the Subsonic music streaming service
# Designed for Ubuntu Server 16.04 and Debian 8 Jessie

# First, install the required packages
apt-get -y install openjdk-8-jre iptables-persistent

# Next, grab Subsonic from www.subsonic.org
wget -O ~/subsonic.deb http://subsonic.org/download/subsonic-6.0.deb

# Now install Subsonic from the .deb archive
sudo dpkg -i ~/subsonic.deb

# Create a new user to run Subsonic under
useradd -M subsonic -s /bin/false

# Disable password login for the new user
passwd -l subsonic

# Modify /etc/defaults/subsonic to run as the new user, and allocate more memory
# (ports higher than 1024 are required for non-privileged users)
echo "SUBSONIC_ARGS=\"--http-port=4080 --https-port=40443 --max-memory=1500\"
SUBSONIC_USER=subsonic" > /etc/defaults/subsonic

# Create required directories, and give the new user ownership
mkdir  /var/music /var/playlists
chown -R subsonic:subsonic /var/music /var/playlists /var/subsonic

# Redirect external port 443 to the actual port in use 40443
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 40443

# Since Subsonic provides no native method for disabling HTTP access, redirect insecure access to the secure port
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 40443

# Tell iptables-persistent to save iptables rules
dpkg-reconfigure iptables-persistent

# Start subsonic
service subsonic start
