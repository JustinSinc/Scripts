#!/bin/bash
echo -e "What is the name of the new user?"
read username
public="/home/public"
home="/home/$username"
www="/var/www/sites/$username"
useradd -m -s $(which zsh) -G sshuser,shell $username
temppass="changeme$(date +%m%d%Y%N)"
echo "$username:$temppass" | sudo chpasswd
cp $public/.zshrc $home
chown $username:$username $home/.zshrc
mkdir $www
ln -s $www $home/www
cp $public/index.html $www
chmod -R 755 $www
chown -R $username:www-data $www
chmod -R 700 $home
echo -e "The new user has been created.
Please use the credentials $username:$temppass."
