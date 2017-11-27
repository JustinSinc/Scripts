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
echo -e "Enter old ONT MAC address, or type \`quit\` to quit: "
read old_mac

# check for quit
check_old="${#old_mac}"
if [ "$old_mac" = "quit" ];
  then exit;
elif [ "$check_old" -ne 12 ];
  then echo "MAC address must be 12 characters.";
  exit;
else
  echo "Old MAC is "$old_mac";
fi

# prompt for gmn account
echo -e "\nEnter new ONT MAC address, or type \`quit\` to quit: "
read new_mac

# check for correct length of mac address
check_new="${#new_mac}"
if [ "$new_mac" = "quit" ];
  then exit;
elif [ "$check" -ne 12 ];
  then echo "MAC address must be 12 characters.";
  exit;
else
  echo "New MAC is "$new_mac";
fi

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
      echo "Quitting..."; exit;;
    *)
      echo "Invalid option. Try again."; continue;;
  esac

done
