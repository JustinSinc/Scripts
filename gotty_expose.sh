#!/usr/bin/env bash
# exposes applications on port 8080 using GoTTY and docker

# exit if a command fails
set -o errexit

# exit if required variables aren't set
set -o nounset

# return the exit status of the final command before a failure
set -o pipefail

# set variables to empty if not declared
arg1="${1:-}"
arg2="${2:-}"
arg3="${3:-}"

# set the port for gotty to listen on
gotty_port="8080"

# set the login username and password
gotty_user="admin"
gotty_pass="admin"

## set limits per exposed application
# cores
cpu_limit="1"

# memory
mem_limit="64m"

# memory+swap
swap_limit="128m"

# kernel memory
kmem_limit="64m"

# if no arguments are supplied, help the user out
if [ "$#" -eq 0 ]; then
        echo "Usage: expose [title] <application> [arguments]"

# if a single argument is supplied, assume it's the application being shared
elif [ "$#" -eq 1 ]; then
        gotty --credential "$gotty_user":"$gotty_pass" --port "$gotty_port" -w -- docker run --interactive --tty --rm --cpus="$cpu_limit" --memory="$mem_limit" --memory-swap="$swap_limit" --kernel-memory="$kmem_limit" -- alpine:latest /bin/ash -c "apk add --update "$arg1" > /dev/null 2>&1;"$arg1""

# if two arguments are supplied, the first will be the tab title and the second the application
elif [ "$#" -eq 2 ]; then
        gotty --credential "$gotty_user":"$gotty_pass" --port "$gotty_port" -w --title-format "$arg1" -- docker run --interactive --tty --rm --cpus="$cpu_limit" --memory="$mem_limit" --memory-swap="$swap_limit" --kernel-memory="$kmem_limit" -- alpine:latest /bin/ash -c "apk add --update "$arg2" > /dev/null 2>&1;"$arg2""

# arguments after the first two are assumed to be meant for the application being shared
else
        gotty --credential "$gotty_user":"$gotty_pass" --port "$gotty_port" -w --title-format "$arg1" -- docker run --interactive --tty --rm --cpus="$cpu_limit" --memory="$mem_limit" --memory-swap="$swap_limit" --kernel-memory="$kmem_limit" -- alpine:latest /bin/ash -c "apk add --update "$arg2" > /dev/null 2>&1;"$arg2" "$arg3""
fi
