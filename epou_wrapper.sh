#!/bin/rzsh
# script to deprovision epon onts

# set required variables
title="EPON deprovisioning script"
olt=("gmn-evr-eolt1" "gmn-evr-eolt2" "gmn-pone-eolt1" "Quit")
confirm=("Yes" "No")

# clear screen
clear

# display script title
echo -e "\n $title \n"

# set prompt
PS3="Select an OLT:"

# prompt for olt choice
select olt_choice in "${olt[@]}"; do
  case "$olt_choice" in
    "gmn-evr-eolt1")
      final_olt="$olt_choice"; break;;
    "gmn-evr-eolt2")
      final_olt="$olt_choice"; break;;
    "gmn-pone-eolt1")
      final_olt="$olt_choice"; break;;
    "Quit")
      echo "Exiting..."; exit;;
    *)
      echo "Invalid option. Try again."; continue;;
  esac
done

# prompt for gmn account
echo -e "\nEnter ONT MAC address: "
read ont_mac

# set blank prompt
PS3=''

# confirm selected command
echo -e "\nYou're deprovisioning "$ont_mac" on "$olt_choice". Is that correct?\n"

# prompt for final confirmation
select confirmation in "${confirm[@]}"; do

  case "$confirmation" in
    "Yes")
      echo "Deprovisioning ONT..."; ssh intranet epou "$olt_choice" "$ont_mac"; break;;
    "No")
      echo "Exiting..."; exit;;
    *)
      echo "Invalid option. Exiting..."; exit;;
  esac

done
