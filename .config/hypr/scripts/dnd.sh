#!/bin/bash

if [ "$(makoctl mode)" == "do-not-disturb" ]; then
    notify-send "DND OFF"
    makoctl mode -r do-not-disturb && echo "Do Not Disturb Mode OFF"
else
    notify-send "DND OFF"
    makoctl mode -s do-not-disturb && echo "Do Not Disturb Mode ON"
fi

