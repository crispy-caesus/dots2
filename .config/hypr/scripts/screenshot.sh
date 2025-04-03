#!/bin/bash

temp_screenshot="/tmp/screenshot.png"

while getopts "asemf" flag; do
  case "${flag}" in
    a) grimblast copy area;;
    s) grimblast copy screen;;
    e) grimblast copysave area $temp_screenshot && swappy -f $temp_screenshot;;
    m) grimblast copy output;;
    f) grimblast --freeze copysave area $temp_screenshot && swappy -f $temp_screenshot;;
  esac
done

echo $temp_screenshot

rm "$temp_screenshot"
