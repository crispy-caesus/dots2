#!/bin/sh

# Check if AGS is running
if pgrep -f "agsv1" > /dev/null; then
    # If running, kill it
    pkill agsv1
else
    # If not running, start it
    agsv1 &
fi

