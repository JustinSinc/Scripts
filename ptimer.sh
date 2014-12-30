#!/bin/bash
STARTTIME=$(date "+%s.%N")
$*
PROCESSTIME=$(echo "$(date +%s.%N)-$STARTTIME" | bc)
echo -e "\nProcess took $PROCESSTIME seconds.\n"
