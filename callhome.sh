#!/bin/bash

# change to no if you want to set remote server info interactively
unattended=yes

# set information for remote server
if [ "$unattended" = "yes" ]; then
	user=root
	address=192.184.82.89
	port=443
else
	# set username
	clear
	echo -e "What is your username on the remote machine?\n"
	read username
	# set IP address
	clear
	echo -e "What is the IP address or URL of the remote machine?\n"
	read address
	# set port
	clear
	echo -e "What is the SSH port on the remote machine?\n"
	read port
fi

# generate SSH key if needed
if [ -a /root/.ssh/id_rsa ]; then
	echo "SSH key already exists."
else
	ssh-keygen -f /root/.ssh/id_rsa 2>&1
	echo "SSH key generated in /root/.ssh/id_rsa"
fi

# copy ssh key over to home
ssh-copy-id "$user@$address -p $port"

# create log file
touch /var/log/tunnel.log

# complete registration
registered_port=$(ssh -p $port $user@$address 'register && tail -1 /var/log/raspi.log | cut -d " " -f 2')

# create tunnel script
cat > /usr/bin/tunnel << EndOfMessage
#!/bin/bash
createTunnel() {
  /usr/bin/ssh -p $port -N -R $registered_port:localhost:22 $user@$address 
  if [[ \$? -eq 0 ]]; then
    echo Called home successfully.
  else
    echo An error occurred calling home. RC was $?
  fi
}
/bin/pidof ssh
if [[ \$? -ne 0 ]]; then
  echo Creating new tunnel connection
  createTunnel
fi
EndOfMessage

# set tunnel to executable
chmod 700 /usr/bin/tunnel

# write out current crontab
crontab -l > ./tmpcron

# add line to execute tunnel
echo "*/1 * * * * /usr/bin/tunnel > tunnel.log 2>&1" >> ./tmpcron

# write back to crontab
crontab ./tmpcron

# clean up
rm ./tmpcron

# finish up
clear
echo -e "\nRegistration appears to have been successful.\n
Check /var/log/raspi.log on the remote server for registration info.\n
Connect to the reverse shell by running 'ssh -p $registered_port localhost' on the remote server.\n"
