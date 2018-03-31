#!/bin/vbash

if [ "$#" -lt 6 ]; then
	echo "Usage: forward <rule> <internal ip> <external port> <internal port> <tcp|udp> <DESC>"
	exit
fi

/bin/vbash << EOF
source /opt/vyatta/etc/functions/script-template
configure
set firewall name STATEFUL rule "$1" description "$6"
set firewall name STATEFUL rule "$1" action 'accept'
set firewall name STATEFUL rule "$1" destination address "$2"
set firewall name STATEFUL rule "$1" destination port "$4"
set firewall name STATEFUL rule "$1" protocol "$5"
set nat destination rule "$1" description "$6"
set nat destination rule "$1" destination port "$3"
set nat destination rule "$1" inbound-interface 'eth1'
set nat destination rule "$1" protocol "$5"
set nat destination rule "$1" translation address "$2"
set nat destination rule "$1" translation port "$4"
commit
EOF
