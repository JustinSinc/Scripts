#!/bin/bash
echo "What is the port you would like to forward?"
read port_in 
echo "What IP would you like to forward to? (192.168.122.x)"
read ip
echo "What is the destination port?"
read port_out 
iptables -t nat -A PREROUTING -p TCP --dport $port_in -j DNAT --to-destination $ip:$port_out
iptables -I FORWARD -m state -d 192.168.122.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT
