#!/bin/bash
# a script to generate new discord musicbots for /r/CasualConversation kill and delete any existing musicbot instances
echo "Removing any existing bot instances..."

for i in "$(docker ps | grep musicbot | cut -d " " -f1)"; do
        docker kill "$i";
        docker rm "$i";
        echo "Killed container "$i"...";
done

# start in user's home dir
cd ~

# create a temporary working directory
tempdir='musicbot$(date "+%Y%m%d%H%M%S")'
mkdir ~/"$tempdir"
cd ~/"$tempdir"

# grab the Dockerfile and configuration directory, then move into the Docker build directory
curl http://musicbot.url/musicbotv3.tar | tar x
cd ./musicbot

# build a new docker image
docker build -t musicbot .

# remove the build directory
cd ~
rm -rf ~/"$tempdir"

# run a new instance of musicbot in the background
docker run -d musicbot
