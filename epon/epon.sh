#!/bin/rzsh
# wrapper for epon config scripts

# set required variables
title="EPON config menu"
actions=("Provision new ONT" "Swap ONT" "Deprovision ONT" "Quit")
confirm=("Yes" "No")

# clear screen
clear

# display script title
echo -e "\n $title"

# set prompt
PS3="Select an action: "

# prompt for action
select desired_action in "${actions[@]}"; do
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
