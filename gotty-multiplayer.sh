#!/usr/bin/env bash
# creates a multiplayer sysadmin experience via docker, GoTTY, and tmux

# exit if a command fails
set -o errexit

# exit if required variables aren't set
set -o nounset

# return the exit status of the final command before a failure
set -o pipefail

# accepts a linux distro name as an argument
distro="$1"

# set variables to empty if not declared
arg1="${1:-}"
arg2="${2:-}"
arg3="${3:-}"

# set the port for gotty to listen on
gotty_port="1337"

# set the login username and password
gotty_user="admin"
gotty_pass="hailhydra"

## set resource limits
# cores
cpu_limit="2"

# memory
mem_limit="512m"

# memory+swap
swap_limit="512m"

# kernel memory
kmem_limit="64m"

# remove old container, if any
docker rm -f tryme && echo "Removed old docker container..."

# kill any existing multiplayer sessions, and start a new one
tmux has-session -t tryme && tmux kill-session -t tryme && echo "Killed old tmux session..." 2>&1 >/dev/null
tmux -2 new-session -d -s tryme
echo "Created new tmux session..."

# create a tmux session, and run docker in window 1
tmux new-window -t tryme:1 -n 'Docker'
tmux select-window -t tryme:1
tmux send-keys "docker run -it --rm --name="tryme" --hostname="multiplayer" --cpus="$cpu_limit" --memory="$mem_limit" --memory-swap="$swap_limit" --kernel-memory="$kmem_limit" --cidfile="$HOME/container_id" -- "$distro":latest "/bin/bash"" C-m
echo "Created container..."

# create a second window for gotty
tmux new-window -t tryme:2 -n 'Gotty'
tmux select-window -t tryme:2
tmux send-keys "gotty --title-format 'Multiplayer Sysadmin!' --credential "$gotty_user":"$gotty_pass" --port "$gotty_port" -w -- docker attach tryme" C-m
echo "Launched GoTTY..."

# join in the fun
tmux select-window -t tryme:1
tmux -2 attach-session -t tryme
