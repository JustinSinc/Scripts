#!/bin/rzsh
# wrapper for epon config scripts

# set required variables
actions=("Provision new ONT" "Swap ONT" "Deprovision ONT" "Quit")

# set prompt
PS3="->"

# clear screen
clear

# display script title
echo -e "\nEPON config menu"

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
