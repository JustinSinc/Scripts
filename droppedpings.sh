#!/usr/bin/env bash
## quick script to identify dropped packet sequences from raw *nix ping output

# fail in a sane manner
set -euo pipefail

# make sure a single filename is used as an argument
if [ "$#" -ne 1 ];
        then echo -e "\nUsage: droppedpings <filename>, where <filename> contains raw ping output.\n"
        exit
fi

# read file | parse out everything before the icmp_seq value | remove the icmp_seq= string | sort the values numeric$
cat "$1" | cut -d " " -f5 | cut -d "=" -f2 | sort -V | awk '$1!=p+1{print p+1"-"$1-1}{p=$1}'
