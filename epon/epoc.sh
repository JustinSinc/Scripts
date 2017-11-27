#!/bin/rzsh
# script to configure epon onts

# set required variables
olt=("gmn-evr-eolt1" "gmn-evr-eolt2" "gmn-pone-eolt1" "Quit")
service=("data" "datatv" "svlan" "Quit")
speed=("70" "100" "Quit")
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

# clear screen
clear

# prompt for ont mac address
echo -e "Enter ONT MAC address, or type \`quit\` to quit: "
read final_mac

# check for quit or incorrect mac address length
check="${#final_mac}"
if [ "$final_mac" = "quit" ];
  then exit;
elif [ "$check" -ne 12 ];
  then echo "MAC address must be 12 characters.";
  exit;
fi

# clear screen
clear

# prompt for gmn account
echo -e "\nEnter GMN account: "
read final_acct

# clear screen
clear

# set title
echo -e "\nSelect a service type:"

# prompt for service type
select service_choice in "${service[@]}"; do

  case "$service_choice" in
    "data")
      final_service="$service_choice"; break;;
    "datatv")
      final_service="$service_choice"; break;;
    "svlan")
      final_service="$service_choice"; break;;
    "Quit") 
       echo "Exiting..."; exit;;
     *)
       echo "Invalid option. Try again."; continue;;
  esac

done
  
# clear screen
clear

# set title
echo -e "\nSelect a service speed:"

# prompt for service speed
select speed_choice in "${speed[@]}"; do

  case "$speed_choice" in
    "70")
      final_speed="$speed_choice"; break;;
    "100")
      final_speed="$speed_choice"; break;;
    "Quit")
      echo "Exiting..."; exit;;
    *)
      echo "Invalid option. Try again."; continue;;
  esac

done

# clear screen
clear

# confirm selected command
echo -e "\nSelected command is \`epoc "$final_olt" "$final_mac" "$final_acct" "$final_service" "$final_speed"\`. Is that correct?"

# prompt for final confirmation
select confirmation in "${confirm[@]}"; do

  case "$confirmation" in
    "Yes")
      echo -e "\nConfiguring ONT..."; ssh intranet epoc "$final_olt" "$final_mac" "$final_acct" "$final_service" "$final_speed"; break;;
    "No")
      echo "Exiting..."; exit;;
    *)
      echo "Invalid option. Try again."; continue;;
  esac

done
