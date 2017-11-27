#!/bin/rzsh
# wrapper for epon config scripts

# set required variables
title="EPON config menu"
olt=("Provision new ONT" "Swap ONT" "Deprovision ONT" "Quit")
confirm=("Yes" "No")

# clear screen
clear

# display script title
echo -e "\n $title \n"

# set prompt
PS3="Select an action: "

# prompt for olt choice
select desired_action in "${olt[@]}"; do
  case "$desired_action" in
    "Provision new ONT")
      epoc; break;;
    "Swap ONT")
      epop; break;;
    "Deprovision ONT")
      epou; break;;
    "Quit")
      echo "Exiting..."; exit;;
    *)
      echo "Invalid option. Try again."; continue;;
  esac
done
