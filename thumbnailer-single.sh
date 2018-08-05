#!/usr/bin/env bash
# image thumbnailing script via gnu parallel and imagemagick

# exit if a command fails
set -o errexit

# exit if required variables aren't set
set -o nounset

# return the exit status of the final command before a failure
set -o pipefail

# set the base directories
olddir="/home/sinc/Dropbox/Private/Misc/Original"
newdir="/home/sinc/Dropbox/Private/Misc/Resized/"

# set the subdirectory
if [ "$(pwd)" != "$olddir" ]; then
	subdir="$(basename $(pwd))/"
	if [[ ! -e "$newdir""$subdir" ]]; then
		mkdir "$newdir""$subdir"
	fi
else
	subdir=""
fi

# run parallel conversions via imagemagick, using all but one core
if [[ "$1" = *.png ]]; then
	echo "File is a png. Converting..."
	parallel -j "$(echo "$(nproc --all)-1" | bc)" convert {} -resize 1440x1440 "$newdir""$subdir"{.}_small.png ::: "$1"
elif [[ "$1" = *.jpg ]]; then
	echo "File is a jpg. Converting..."
	parallel -j "$(echo "$(nproc --all)-1" | bc)" convert {} -resize 1440x1440 "$newdir""$subdir"{.}_small.png ::: "$1"
else
	echo "File is not a jpg or png"
fi
