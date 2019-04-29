#!/usr/bin/env bash
# a script to add vendor id to Cisco IOS' `show mac address-table` output

# exit if a command fails
set -o errexit

# exit if required variables aren't set
set -o nounset

# return the exit status of the final command before a failure
set -o pipefail

# if no arguments are passed, accept user input
if [ "$#" -eq 0 ]; then
	# prompt the user for input
	echo -e "\nPaste the output of \`show mac address-table\`, and then type "\$": "
	
	# create a tempfile to store user input
	input="$(mktemp)"

	# read user input, delimited by the `$` character
	read -s -r -d '$' VAR

	# store the user input in the created tempfile
	echo "$VAR" > "$input"
# if a single argument is passed, use that as the input file
elif [ "$#" -eq 1 ]; then
	# give the input file a variable name for readability
	input="$1"
# otherwise, print usage syntax
else
	echo -e "\nUsage: "$0" [filename]\n"
	echo -e "If no arguments are provided, accept input from stdin\n"
	exit 1
fi

# set log file location
logfile="mac-lookup.log"

# create a temporary file to store the processed text
tempfile="$(mktemp)"

# prepend timestamp to logfile
echo -e "\nScript execution began at $(date +%Y/%m/%d-%H:%M)." >> "$logfile" 2>&1

# wrap the script into a function for logging purposes
{

# display location of temp file for debugging purposes
echo "Storing output in tempfile "$tempfile"..."

# if no oui database exists in the working directory, download an up-to-date copy
if [ ! -f oui.txt ]; then
	wget -q http://standards-oui.ieee.org/oui.txt;
	echo "oui.txt not found; downloaded from ieee.org...";
fi

# iterate through each line and process the text into a more readable format
# the `-r` argument for `while` prevents interpreting backslash escapes;
# these should not be present, but better to be safe than sorry
while read -r i; do
	# store first column into vlan variable
	vlan="$(echo "$i" | awk '{print $1}')"
	
	# store second column into mac variable
	mac="$(echo "$i" | awk '{print $2}')"
	
	# store third column into port variable
	port="$(echo "$i" | awk '{print $4}')"
	
	# convert mac address from second column into oui format (first six characters, all uppercase)
	oui_temp="$(mktemp)"					# create a tempfile to store the processed oui
	echo "$i" |								# display the line for parsing
	awk '{print $2}' |						# display only second column (mac address)
	sed 's/\.//g' |						 	# remove all periods from the string
	awk '{print toupper($0)}' |			 	# convert all alphabetic characters to uppercase
	cut -c "1-6" |							# only display the first six characters
	fold -w2 |								# split the string into groups of two characters each
	paste -sd'-' - >> "$oui_temp"			# insert a `-` delimiter between those groups, per oui format
	oui="$(cat "$oui_temp")"				# store the oui in a variable
	
	# match the newly parsed oui with the vendor name, retrieved from the oui database
	vendor_temp="$(mktemp)"				 	# create a tempfile to store the processed vendor id
	grep "$oui" oui.txt |					# find the relevant line in the oui database
	awk '{$1=$2=""; print $0}' |			# strip the hex oui string and format type columns
	awk '{$1=$1;print}' >> "$vendor_temp"	# strip leading whitespace
	vendor="$(cat "$vendor_temp")"			# store the vendor id in a variable
	
	# store the processed output in the previously-created tempfile
	echo -e	"$port\t$vlan\t$mac\t$vendor" >> "$tempfile"
done < "$input"

# end function
} 2>&1 | tee -a "$logfile" >/dev/null

# append timestamp to logfile
echo -e "Script execution finished at $(date +%Y/%m/%d-%H:%M).\n" >> "$logfile"

# display the sorted list, with a blank line on either side
echo ""
sort -V "$tempfile"
echo ""
