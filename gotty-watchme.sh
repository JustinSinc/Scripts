#!/usr/bin/env/bash

# kill any existing GoTTYs
#pkill gotty

# spawn new GoTTY session in a tmux session named "watchme"
tmux has-session -t watchme || tmux new-session -d -s watchme
tmux send -t watchme "gotty -p 1338 --title-format "Watch Me" tmux a -t watchme" Enter

# connect to the tmux session locally
tmux a -t watchme
