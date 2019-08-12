#!/bin/bash

# usage: ./thumbnail.sh <directory>

base_dir="/storage/archive"
orig_path=""$base_dir"/"$1""
thumb_path=""$base_dir"/thumbnails/"$1""

rm /tmp/commands.txt

mkdir -p "$thumb_path"

cd "$orig_path"

for orig in *; do echo "exiftool -PreviewImage -b "$orig" > "$thumb_path"/"$orig".jpg" >> /tmp/commands.txt; done

parallel --no-notice --jobs 8 < /tmp/commands.txt

mogrify -resize 640x640 "$thumb_path"/*.jpg
