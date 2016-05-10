#!/bin/bash

# Occasionally my autossh tunnels time out and fail to renew themselves.
# This script kills any existing autossh connections, and tunnels to my jump host
# and then restarts them.

# Requires autossh, ssh

# assign the hostname of the tunnel host here
tunnel_host="gate"

# assign the local port for the tunnel here
tunnel_port="1336"

# assign the autossh monitor port here
monitor_port="2050"

# assign $old_tunnel to the PIDs, if any, of existing SSH connections to host "$tunnel_host"
old_tunnel="$(ps ax | grep ssh | grep "$tunnel_host" | grep -v grep | awk '{ print $1 }')""

# if an SSH tunnel exists, kill it
if [ -n "$old_tunnel" ]; then
        echo -n "Removing existing SSH tunnel... "
        kill -9 $old_tunnel
        echo "Done!"
        sleep 5
else
        echo "There is no current tunnel."
fi

# create new tunnel
echo -n "Creating new one... "
autossh -M "$monitor_port" -f -N -D "$tunnel_port" "$tunnel_host"
echo "Done!"
