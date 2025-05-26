#!/bin/bash

OPTIONS=a,s,e,m,f
LONGOPTS=area,screen,edit,monitor,freeze,freezeedit

PARSED=$(getopt --options="$OPTIONS" --longoptions="$LONGOPTS" -- "$@")
eval set -- "$PARSED"

while true; do
    case "$1" in
        -a|--area) grim -g "$(slurp)" - | wl-copy
            shift;;
        -s|--screen) grim - | wl-copy
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
