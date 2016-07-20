#!/bin/bash

# shell script best practice
set -euo pipefail

# remove any leftover backup files, suppressing errors if none exist
rm /home/sinc/audio/*.bak 2> /dev/null

# add any new mp3 files to the page
for i in /home/sinc/audio/*.mp3; do
    # create an HTML5 audio tag for any .mp3 audio clips
    sed -i.bak "/<!-- Begin -->/a <br />"$i"<br /><audio controls> <source src=\"/audio/$i\" type="audio/mp3"> Your browser does not support the audio tag. </audio>" index.html

    # move the audio file to the webroot and make it readable
    mv $i /var/www/html/audio/
    chmod 755 /var/www/html/audio/$i
done

# add any new ogg vorbis files to the page
for i in /home/sinc/audio/*.ogg; do
    # create an HTML5 audio tag for any .ogg audio clips
    sed -i.bak "/<!-- Begin -->/a <br />"$i"<br /><audio controls> <source src=\"/audio/$i\" type="audio/ogg"> Your browser does not support the audio tag. </audio>" index.html

    # move the audio file to the webroot and make it readable
    mv $i /var/www/html/audio/
    chmod 755 /var/www/html/audio/$i
done

# move the updated index.html to the webroot
cp /home/sinc/audio/index.html /var/www/html/index.html
