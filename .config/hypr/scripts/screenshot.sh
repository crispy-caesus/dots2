#!/bin/bash

temp_screenshot="/tmp/screenshot.png"

OPTIONS=a,s,e,m,f
LONGOPTS=area,screen,edit,monitor,freeze

PARSED=$(getopt --options="$OPTIONS" --longoptions="$LONGOPTS" -- "$@")
eval set -- "$PARSED"

while true; do
    case "$1" in
        -a|--area) grimblast copy area
            shift;;
        -s|--screen) grimblast copy screen
            shift;;
        -e|--edit) grimblast copysave area $temp_screenshot && swappy -f $temp_screenshot
            shift;;
        -m|--monitor) grimblast copy output
            shift;;
        -f|--freeze) grimblast --freeze copysave area $temp_screenshot && swappy -f $temp_screenshot
            shift;;
        --) shift; break;;
    esac
done

echo $temp_screenshot

rm "$temp_screenshot"
