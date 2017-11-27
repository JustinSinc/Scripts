#!/bin/rzsh
# script to deprovision epon onts

# set required variables
olt=("gmn-evr-eolt1" "gmn-evr-eolt2" "gmn-pone-eolt1" "Quit")
confirm=("Yes" "No")

# clear screen
clear

# prompt for olt choice
echo -e "\nSelect an OLT"

# set prompt
PS3="->"

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

# prompt for ont mac address
echo -e "Enter ONT MAC address, or type \`quit\` to quit: "
read ont_mac

# check for quit or incorrect mac address length
check="${#ont_mac}"
if [ "$ont_mac" = "quit" ];
  then exit;
elif [ "$check" -ne 12 ];
  then echo "MAC address must be 12 characters.";
  exit;
fi

# set blank prompt
PS3='->'

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
      echo "Invalid option. Try again."; continue;;
  esac

done
