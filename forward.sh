#!/usr/bin/env bash

bridge_interface="$(lxc network list | grep bridge | head -n1 | cut -d " " -f2)"
bridge_subnet="$(lxc network show "$bridge_interface" | grep ipv4.address | cut -d " " -f 4)"
my_ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"

operation="$1"
protocol="$2"
outside_port="$3"
destination="$4"
inside_port="$5"

# shell script best practice
set -euo pipefail

# if no arguments are supplied, help the user out
if [ $# -eq 0 ];
	then echo -e "\nBridge subnet: "$bridge_subnet"\n"
		 echo -e "Active containers:"
		 echo -e "$(lxc list | grep RUNNING | cut -d "|" -f 2-4)\n"
fi

# make sure there are the correct number of arguments
if [ $# -ne 5 ];
	then echo -e "Usage: forward <add|del> <tcp|ip> <outside port> <destination address> <inside port>\n"
	exit
fi

# figure out what operation is being requested
if [ "$1" = "add" ]; then
	# create the port forward
	sudo iptables -t nat -A PREROUTING -p "$protocol" -i eno1 --dport "$outside_port" -j DNAT --to-destination "$destination":"$inside_port" 

	# let the user know
	echo -e "Created port forward "$my_ip":"$outside_port" => "$destination":"$inside_port".\n"

elif [ "$1" = "del" ]; then
	# remove the port forward
	sudo iptables -t nat -D PREROUTING -p "$protocol" -i eno1 --dport "$outside_port" -j DNAT --to-destination "$destination":"$inside_port" 

	# let the user know
	echo -e "Removed port forward "$my_ip":"$outside_port" => "$destination":"$inside_port".\n"
	
else
	echo -e "Please specify either add or remove operation.\n"
fi
