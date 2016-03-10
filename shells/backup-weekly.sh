#!/bin/bash

# Copy the most recent day's backups to remote backup server
rsync -avuh --ignore-existing --delete -e "ssh -p 443" --partial /storage/backups/$(date +%Y%m%d)/*.tgz storage:/backups/
