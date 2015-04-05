#!/bin/bash
echo "What is the port you would like to forward?"
read port_in
echo "What IP would you like to forward to?"
read ip
iptables -t nat -I PREROUTING -p tcp --dport $port_in -j DNAT --to-destination $ip:22
iptables -I FORWARD -m state -d 192.168.122.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT
