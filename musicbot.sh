#!/bin/bash

# kill and delete any existing musicbot instances
echo "Removing any existing bot instances..."

for i in "$(docker ps | grep musicbotv2 | cut -d " " -f1)"; do
        docker kill "$i";
        docker rm "$i";
        echo "Killed container "$i"...";
done

# run a new instance of musicbot in the background
docker run -d musicbotv2

echo "New instance spawned..."
