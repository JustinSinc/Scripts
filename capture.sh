#!/bin/bash

interfaces=$(ip a | egrep "[0-9]: " | cut -d " " -f 2 | tr -d [=:=])

clear

echo -e "What interface would you like to capture on?
Available options are:\n $interfaces\n\n\n Interface:"

read interface

echo -e "What type of packet would you like to capture?\n
Options: DNS, DHCP, HTTP, SSL, ARP"

read protocol

clear

echo -e "Capturing $protocol packets."

if [ $protocol == "DHCP" ]; then
    tshark -i $interface -Y "bootp.option.type == 53"
elif [ $protocol == "DNS" ]; then
    tshark -i $interface -Y "dns"
elif [ $protocol == "HTTP" ]; then
    tshark -i $interface -Y "http"
elif [ $protocol == "SSL" ]; then
    tshark -i $interface -Y "ssl"
elif [ $protocol == "ARP" ]; then
    tshark -i $interface -Y "arp"
else 
    echo "Invalid protocol. Please re-run the script."
    exit 1
fi

