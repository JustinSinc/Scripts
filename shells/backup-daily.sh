#!/bin/bash

# Set $date to current date, in format YYYYMMDD
date=$(date +%Y%m%d)

# Create directory in /storage/backups/ titled with current date
mkdir /storage/backups/$date

# Move to current backup directory
cd /storage/backups/$date

# List all users in the sshuser group (default for shell accounts)
for user in $(getent group sshuser | cut -d ":" -f 4 | tr "[=,=]" "\n"); do
  # Tarball each user's home directory in format $user_home_$date.tar.gz
  tar -zcvf "$user"_home_"$date".tgz /home/$user
  # Tarball each user's ~/www directory in format $user_www_$date.tar.gz
  tar -zcvf "$user"_www_"$date".tgz /var/www/sites/$user
done
