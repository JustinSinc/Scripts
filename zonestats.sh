#!/usr/bin/env bash

# bash best practices
set -o errexit
set -o pipefail
set -o nounset

# display system information
hwinfo="$(prtconf)"
vmlist="$(vmadm list)"
echo -e "\nSmartOS running on a system with "$(echo "$hwinfo" | grep cpu | wc -l | sed 's/^[\t ]*//g')" CPU thread$
echo -e "There are currently "$(echo "$vmlist" | grep OS | wc -l | sed 's/^[\t ]*//g')" Solaris zones and "$(echo $

# display storage information
diskstats="$(zpool list | tail -n +2)"
echo -e "\nStorage info:"
echo -e "--------------------------"
echo -e "Disk used: $(echo "$diskstats" | cut -d " " -f 6)/$(echo "$diskstats" | cut -d " " -f 4)"
echo -e "Deduplication ratio: $(echo "$diskstats" | cut -d " " -f 30)"
echo -e "Compression ratio: $(zfs get compressratio zones | tail -n +2 | cut -d " " -f 5)"
echo -e "--------------------------\n"

# display disk usage by zone
disktemp="$(mktemp)"
echo "Zone disk usage                       AVAIL   USED"
echo "--------------------------------------------------"
for i in $(vmadm list | tail -n +2 | cut -d " " -f1)
        do zfs list -o space zones/"$i" | tail -n +2 | cut -c 7-58 >> "$disktemp"
done
sort < "$disktemp"
echo "--------------------------------------------------"

# display memory usage by zone
zone_mem="$(zonememstat | tail -n +3 | sort)"
mem_used="$(echo "$zone_mem" | awk '{ sub(/^[ \t]+/, ""); print }' | awk '{s+=$2}END{print s}')"

memtemp="$(mktemp)"
if [ "$mem_used" -ge "1024" ]; then
  echo "$(echo "scale=2; "$mem_used" / 1024" | bc )"G > "$memtemp"
else
  echo "$mem_used"M > "$memtemp"
fi

mem_used="$(< "$memtemp")"

echo -e "\nZone memory usage                         Used    Max"
echo -e "-------------------------------------------------------"
echo -e "$(echo "$zone_mem" | awk '{print $1"M     "$2"M     "$3"M"}')"
echo -e "-------------------------------------------------------"
echo -e "                               Total:    "$mem_used"\n"

# display overall memory usage
memstats="$(echo ::memstat | mdb -k)"
echo -e "Page Summary                Pages                MB  Used"
echo -e "---------------------------------------------------------"
echo -e "$(echo "$memstats" | tail -n +3 | awk NF | sed '$d' | sed '$d')"
echo -e "---------------------------------------------------------\n"

# display interface status
echo -e "LINK         MEDIA                STATE      SPEED  DUPLEX    DEVICE"
echo -e "--------------------------------------------------------------------"
echo -e "$(dladm show-phys | tail -n +2)"
echo -e "--------------------------------------------------------------------\n"
