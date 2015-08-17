#!/bin/bash

# change to no if you want to set remote server info interactively
unattended=yes

# set information for remote server
if [ "$unattended" = "yes" ]; then
	user=
	address=
	port=
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

# create device registration script
echo '#!/bin/bash
last_used_port=$(tail -1 /var/log/raspi.log | awk '\''{ print $2 }'\'')
new_port=$((last_used_port+1))
echo "$(date +%Y%m%d-%H:%M:%S) $new_port" >> /var/log/raspi.log' > /usr/bin/register

# set registration script to executable
chmod 700 /usr/bin/register

# complete registration
ssh -p $port $user@$address "bash -s" < /usr/bin/register &> /var/log/register.log

# store registered port for use in tunnel script
registered_port=$(cat test.log | cut -d " " -f 2)

# create tunnel script
echo -e "#!/bin/bash
createTunnel() {
  /usr/bin/ssh -p $port -N -R $registered_port:localhost:22 $user@$address
  if [[ $? -eq 0 ]]; then
    echo Called home successfully.
  else
    echo An error occurred calling home. RC was $?
  fi
}
/bin/pidof ssh
if [[ $? -ne 0 ]]; then
  echo Creating new tunnel connection
  createTunnel
fi" > /usr/bin/tunnel 2>&1

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
