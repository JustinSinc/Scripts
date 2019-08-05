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
APEX="$(drill soa "$RECORDSET" | grep -v ^\; | grep SOA | awk '{print $1}' | sed 's/\.$//')"

# fetch the zone ID for the apex
ZONEID="$($HOME/.local/bin/aws route53 list-hosted-zones | grep "$APEX" -B1 | head -n1 | cut -d"\"" -f4 | cut -d"/" -f3)"

# set the TTL for the record
TTL="60"

# set the record type to update
TYPE="A"

# add the update time as a comment
COMMENT="Last updated @ `date`"

# fetch our external IP address
NEWIP="$(curl -s ipv4.icanhazip.com)"

# check what the record currently resolves to
OLDIP="$(drill $RECORDSET -4 @1.1.1.1 | grep -A1 "ANSWER SECTION" | grep IN | awk '{ print $5 }')"

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

# log file locations
LOGFILE="/tmp/$RECORDSET.log"
IPFILE="/tmp/$RECORDSET.ip"

# store date for logfile timestampps
DATE="$(date +"%Y/%m/%d %H:%M:%S")"

# make sure the IP address is valid
if ! valid_ip $NEWIP; then
    echo "$DATE Invalid IP address: $NEWIP. Exiting." >> "$LOGFILE"
    exit 1
fi

# check if the IP has changed since we last ran this script
if [ ! -f "$IPFILE" ]
    then
    touch "$IPFILE"
fi

if grep -Fxq "$NEWIP" "$IPFILE" && [ "$NEWIP" = "$OLDIP" ]; then
    # code if found
    echo "$DATE IP is still $NEWIP. Exiting." >> "$LOGFILE"
    exit 0
else
    echo "$DATE IP has changed to $NEWIP. Updating." >> "$LOGFILE"
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
                "Value":"$NEWIP"
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
    echo "" >> "$LOGFILE"
    $HOME/.local/bin/aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONEID \
        --change-batch file://"$TMPFILE" >> "$LOGFILE"
    echo "" >> "$LOGFILE"

    # clean up
    rm $TMPFILE
fi

# cache the IP address for next time
echo "$NEWIP" > "$IPFILE"
