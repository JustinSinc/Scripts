#!/bin/rzsh
# script to swap epon onts

# set required variables
title="EPON swapping script"
confirm=("Yes" "No")

# clear screen
clear

# display script title
echo -e "\n $title \n"

# prompt for olt mac address
echo -e "Enter old ONT MAC address: "
read old_mac

# prompt for gmn account
echo -e "\nEnter new ONT MAC address: "
read new_mac

# set blank prompt
PS3=''

# confirm selected command
echo -e "\nYou're swapping "$old_mac" for "$new_mac". Is that correct?\n"

# prompt for final confirmation
select confirmation in "${confirm[@]}"; do

  case "$confirmation" in
    "Yes")
      echo "Swapping ONTs..."; ssh intranet epop "$old_mac" "$new_mac"; break;;
    "No")
      echo "Quitting..."; break;;
    *)
      echo "Invalid option. Quitting."; break;;
  esac

done
