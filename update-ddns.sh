#!/usr/bin/env bash
# credit to Will Warren for the original script
# https://willwarren.com/2014/07/03/roll-dynamic-dns-service-using-amazon-route53

# check for exactly one argument
if [ "$#" -eq 1 ]; then
        # store the record in a variable
        RECORDSET="$1"
else
        # display usage syntax
        echo -e "Usage: .\update-ddns.sh <cname>"
        exit 1
fi

# fetch the zone apex
APEX="$(dig soa "$RECORDSET" | grep -v ^\; | grep SOA | awk '{print $1}' | sed 's/\.$//')"

# fetch the zone ID for the apex
ZONEID="$(aws route53 list-hosted-zones | grep "$APEX" -B1 | head -n1 | cut -d"\"" -f4 | cut -d"/" -f3)"

# set the TTL for the record
TTL=60

# set the record type to update
TYPE="A"

# add the update time as a comment
COMMENT="Last updated @ `date`"

# fetch our external IP address
IP=`curl ipv4.icanhazip.com`

# check if the IP is in a valid format
function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

# get the current directory
# (from http://stackoverflow.com/a/246128/920350)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOGFILE="$DIR/update-route53-$RECORDSET.log"
IPFILE="$DIR/update-route53-$RECORDSET.ip"

# make sure the IP address is valid
if ! valid_ip $IP; then
    echo "Invalid IP address: $IP" >> "$LOGFILE"
    exit 1
fi

# check if the IP has changed since we last ran this script
if [ ! -f "$IPFILE" ]
    then
    touch "$IPFILE"
fi

if grep -Fxq "$IP" "$IPFILE"; then
    # code if found
    echo "IP is still $IP. Exiting" >> "$LOGFILE"
    exit 0
else
    echo "IP has changed to $IP" >> "$LOGFILE"
    # fill a temp file with valid JSON
    TMPFILE=$(mktemp /tmp/temporary-file.XXXXXXXX)
    cat > ${TMPFILE} << EOF
    {
      "Comment":"$COMMENT",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$IP"
              }
            ],
            "Name":"$RECORDSET",
            "Type":"$TYPE",
            "TTL":$TTL
          }
        }
      ]
    }
EOF

    # update the Hosted Zone record
    aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONEID \
        --change-batch file://"$TMPFILE" >> "$LOGFILE"
    echo "" >> "$LOGFILE"

    # clean up
    rm $TMPFILE
fi

# cache the IP address for next time
echo "$IP" > "$IPFILE"
