#!/bin/bash

# Check if gedit is running
# -x flag only match processes whose name (or command line if -f is
# specified) exactly match the pattern. 

if pgrep -x "hypridle" > /dev/null
then
    notify-send "killing hypridle"
    pkill hypridle
else
    hypridle &
    notify-send "started hypridle"
fi

