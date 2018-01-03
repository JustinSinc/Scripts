#!/usr/bin/env bash
## quick script to identify dropped packet sequences from raw *nix ping output

# read file | parse out everything before the icmp_seq value | remove the icmp_seq= string | sort the values numerically | display dropped sequences
cat "$1" | cut -d " " -f5 | cut -d "=" -f2 | sort -V | awk '$1!=p+1{print p+1"-"$1-1}{p=$1}'
