#!/bin/bash

ssh_port = $(cat /etc/ssh/sshd_config | grep Port | egrep -o '[0-9]+')
intruder = $(grep Failed /var/log/auth.log | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

