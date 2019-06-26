#!/usr/bin/env bash
# a script to add or remove vlan subinterfaces
# from a physical interface

# the first two octets of the subnets to be used
subnet="10.0"

# the subnet mask
mask="24"

# initialise third octet, starting with 0 for the first vlan and incrementing by 1
iteration="0"

# this script should be run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

# check for exactly two arguments
if [ "$#" -eq 2 ]; then
	action="$1"
	interface="$2"

# if that check fails, display usage info
else
	echo -e "Usage: ./vlans <add|del> <interface>\n"
	exit 1
fi

# check if the vlan kernel module is loaded
if !(grep 8021q /proc/modules >/dev/null 2>&1); then
	echo -e "8021q module not loaded.\n"
	exit 1
fi

# function to read input vlans and store as an array
readVlans() {
	vlans=()
	while IFS= read -r line; do
		[[ $line ]] || break
		vlans+=("$line")
	done
}

# if the action is add:
if [[ "$action" == "add" ]]; then
	# prompt for vlan input
	echo "VLANs to add (end with an empty line): "
	readVlans

	# do the following:
	for vlan in "${vlans[@]}"; do
		# create vlan device
		vconfig add "$interface" "$vlan"

		# assign ip address
		ip addr add "$subnet"."$iteration".1/"$mask" dev "$interface"."$vlan"

		# set link state to up
		ip link set dev "$interface"."$vlan" up

		# increment counter
		((iteration += 1))
	done

# otherwise if the action is del:
elif [[ "$action" == "del" ]]; then
	# prompt for vlan input
	echo "VLANs to remove (end with an empty line): "
	echo "Leave this blank to remove all existing vlans."
	readVlans

	# if no vlans are provided, remove all vlans on the interface
	if [[ "${#vlans[@]}" -eq "0" ]]; then
		for vlan in /proc/net/vlan/*.*; do
			vconfig rem "$(basename "$vlan")"
		done
	# otherwise remove the specified vlans
	else
		for vlan in "${vlans[@]}"; do
			vconfig rem "$interface"."$vlan"
		done
	fi

# otherwise, display usage info
else
	echo -e "Usage: ./vlans <add|del> <interface>\n"
	exit 1
fi
