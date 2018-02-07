#!/usr/bin/env bash
# a script to set up a new tinc node

# exit if a command fails
set -o errexit

# exit if required variables aren't set
set -o nounset

# return the exit status of the final command before a failure
set -o pipefail

# set node public ip address
public=""

# set desired tinc version
ver="1.0.33"

# set network name
netname="mesh"

# set node name
node=""

# set tinc directory
root="/usr/local/etc/tinc/"$netname""

# set node ip
private=""

# install dependencies
sudo apt install -y liblzo2-dev libssl-dev gcc zlib1g-dev

# download and compile tinc
wget https://www.tinc-vpn.org/packages/tinc-"$ver".tar.gz
tar xvf tinc-"$ver".tar.gz
cd tinc-"$ver"
./configure
make
make install
cd ..

# clean up
rm tinc-"$ver".tar.gz
sudo rm -rf tinc-"$ver"

# create subdirectories and move to the newly created directory
mkdir -p "$root"/hosts
cd "$root"

# generate tinc.conf
cat << EOF > "$root"/tinc.conf
Name = $node
AddressFamily = ipv4
Device = /dev/net/tun
EOF

# generate tinc-up
cat << EOF > "$root"/tinc-up
#!/bin/sh
ifconfig \$INTERFACE "$private" netmask 255.255.255.0
EOF

# generate tinc-down
cat << EOF > "$root"/tinc-down
#!/bin/sh
ifconfig \$INTERFACE down
EOF

# generate nets.boot
cat << EOF > /usr/local/etc/tinc/nets.boot
mesh
EOF

# make scripts executable
sudo chmod 755 "$root"/tinc-*

# generate keypair
sudo tincd -n "$netname" -K4096

# add additional config lines
sed -i "1s;^;Address\ \=\ "$public"\nSubnet\ \=\ "$private"\/32\n;" "$root"/hosts/"$node"

# create the pid directory
sudo mkdir -p /usr/local/var/run

## Now all you need to do is add the necessary ConnectTo lines to tinc.conf on each node, and copy host files as needed
