#!/usr/bin/env bash
# exposes applications on an arbitrary port using GoTTY and docker

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
gotty_port="1337"

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

# create a tmux session to run in
tmux has-session -t tryme || tmux new-session -d -s tryme
tmux send -t tryme "gotty --title-format 'Try Me!' --credential "$gotty_user":"$gotty_pass" --port "$gotty_port" -w -- docker run --interactive --tty --rm --cpus="$cpu_limit" --memory="$mem_limit" --memory-swap="$swap_limit" --kernel-memory="$kmem_limit" -- alpine:latest /bin/ash" && tmux send-key Enter && tmux send-key n
