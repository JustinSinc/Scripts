#!/bin/bash

# display storage information
echo -e "\nStorage info:"
echo -e "--------------------------"

# display zpool stats
echo -e "Disk used: $(zpool list | tail -n +2 | cut -d " " -f 6)/$(zpool list | tail -n +2 | cut -d " " -f 4)"

# display dedup ratio
echo -e "Deduplication ratio: $(zpool list | tail -n +2 | cut -d " " -f 30)"

# display compression ratio
echo -e "Compression ratio: $(zfs get compressratio zones | tail -n +2 | cut -d " " -f 5)"
echo -e "--------------------------\n"

# display disk usage by zone
disktemp=$(mktemp)
echo "ZONE                                  AVAIL   USED"
echo "--------------------------------------------------"
for i in $(vmadm list | tail -n +2 | cut -d " " -f1)
        do zfs list -o space zones/"$i" | tail -n +2 | cut -c 7-58 >> $disktemp
done
sort < $disktemp
echo "--------------------------------------------------"

# display memory usage by zone
mem_used="$(zonememstat | tail -n +3 | sort | awk '{ sub(/^[ \t]+/, ""); print }' | awk '{s+=$2}END{print s}')"

echo -e "\nZONE                                      Used    Max"
echo -e "-------------------------------------------------------"
echo -e "$(zonememstat | tail -n +3 | sort | awk '{print $1"M     "$2"M     "$3"M"}')"
echo -e "-------------------------------------------------------"
echo -e "                             Total:       "$mem_used"\n"

# display overall memory usage
echo -e "Page Summary                Pages                MB  %Tot"
echo -e "---------------------------------------------------------"
echo -e "$(echo ::memstat | mdb -k | tail -n +3 | awk NF | sed '$d' | sed '$d')"
echo -e "---------------------------------------------------------"
echo -e "$(echo ::memstat | mdb -k | sed '$!d')\n"

# display interface status
echo -e "LINK         MEDIA                STATE      SPEED  DUPLEX    DEVICE"
echo -e "--------------------------------------------------------------------"
echo -e "$(dladm show-phys | tail -n +2)"
echo -e "--------------------------------------------------------------------\n"
