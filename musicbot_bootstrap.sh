#!/bin/bash

# kill and delete any existing musicbot instances
echo "Removing any existing bot instances..."

for i in "$(docker ps | grep musicbot | cut -d " " -f1)"; do
        docker kill "$i";
        docker rm "$i";
        echo "Killed container "$i"...";
done

# start in user's home dir
cd ~

# grab the latest musicbot version
git clone https://github.com/Just-Some-Bots/MusicBot.git ~/MusicBot -b master

# move into the musicbot directory
cd ~/MusicBot

# grab the required configuration and overwrite the existing config directory
curl <URL for tarball of MusicBot/config folder here> | tar xv

# build a new docker image
docker build -t musicbot .

# run a new instance of musicbot in the background
docker run -d musicbot

echo "New instance spawned..."
