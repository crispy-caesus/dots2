#!/bin/bash
swww query
if [ $? -eq 1 ]; then
  swww-daemon --format xrgb &
  swww restore\
    --transition-type "wipe" \
    --transition-duration 2
fi
