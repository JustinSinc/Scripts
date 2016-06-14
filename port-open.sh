#!/bin/bash
# A messy, basic script to forward ports to containers on my hosting servers

# Which protocol is being forwarded?
echo -e "\nProtocol:     (format tcp/udp)\n"
read protocol

# Which address are we forwarding to?
echo -e "\nIP address to forward to:\n"
read forward_to

# Which port are we forwarding?
echo -e "\nPort to forward:\n"
read forwarded_port

# Which port are we forwarding to?
echo -e "\nPort to forward to:\n"
read forwarded_to

# Forward the port using iptables
sudo iptables -t nat -A PREROUTING -p "$protocol" --dport "$forwarded_port" -j DNAT --to "$forward_to":"$forwarded_to"

# Enable the port forward
sudo iptables -A FORWARD -d "$forward_to" -p "$protocol" --dport "$forwarded_port" -j ACCEPT

# Save changes
sudo dpkg-reconfigure iptables-persistent

# Clear the screen, and let the user know the forward succeeded
clear
echo -e "\n"$protocol" port "$forwarded_port" forwarded to port "$forwarded_to" on host "$forward_to".\n\n\n"