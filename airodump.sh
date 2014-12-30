#!/bin/bash

# trap attempted exits
trap "sudo airmon-ng stop mon0" SIGINT SIGTERM

# remove any existing monitor interfaces
for i in `ip a | grep mon | cut -d ":" -f 2 | tr -d "\n"`
do
    sudo airmon-ng stop $i
done

# enable monitor on current wireless interface
wlan=`ip a | grep w | cut -d ":" -f 2 | head -n 1`
sudo airmon-ng start $wlan 6

# begin traffic dump on new monitor interface
sudo airodump-ng --ignore-negative-one mon0
