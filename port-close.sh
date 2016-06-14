#!/bin/bash
# A messy, basic script to remove port forwardings from containers on my hosting servers

# Which protocol was being forwarded?
echo -e "\nProtocol:     (format tcp/udp)\n"
read protocol

# Which address were we forwarding to?
echo -e "\nIP address to forward to:\n"
read forward_to

# Which port were we forwarding?
echo -e "\nPort to forward:\n"
read forwarded_port

# Which port were we forwarding to?
echo -e "\nPort to forward to:\n"
read forwarded_to

# Remove the port forward from iptables
sudo iptables -t nat -D PREROUTING -p "$protocol" --dport "$forwarded_port" -j DNAT --to "$forward_to":"$forwarded_$

# Clear the screen, and let the user know the forward succeeded
clear
echo -e "\n"$protocol" port "$forwarded_port" no longer forwarded to port "$forwarded_to" on host "$forward_to".\n\n\n"
