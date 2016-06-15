#!/bin/sh

# kill any existing GoTTYs
pkill gotty

# spawn new GoTTY session in a tmux session named "run-gotty"
tmux has-session -t run-gotty || tmux new-session -d -s run-gotty
tmux send -t run-gotty "gotty tmux new -A -s gotty /bin/sh" Enter

# connect to the tmux session locally
tmux a -t gotty
