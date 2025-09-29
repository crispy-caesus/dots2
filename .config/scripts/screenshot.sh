#!/bin/bash

OPTIONS=a,s,e,m,f,c
LONGOPTS=area,screen,edit,monitor,freeze,freezeedit,active

PARSED=$(getopt --options="$OPTIONS" --longoptions="$LONGOPTS" -- "$@")
eval set -- "$PARSED"

while true; do
    case "$1" in
        -a|--area) grim -g "$(slurp)" - | wl-copy
            shift;;
        -s|--screen) grim - | wl-copy
            shift;;
        -c|--active) grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | wl-copy
            shift;;
        -e|--edit) exec 3< <(grim -g "$(slurp)" -)
            swappy -f - <&3
            shift;;
        -m|--monitor) grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" - | wl-copy
            shift;;
        -f|--freeze) wayfreeze --hide-cursor --after-freeze-cmd 'grim -g "$(slurp)" - | wl-copy; killall wayfreeze'
            shift;;
        --freezeedit) wayfreeze & PID=$!; sleep .1; kill $PID && exec 3< <(grim -g "$(slurp)" -) && swappy -f - <&3;
            shift;;
        --) shift; break;;
    esac
done
