#!/bin/bash

temp_screenshot="/tmp/screenshot.png"

while getopts "ase" flag; do
  case "${flag}" in
    a) grimblast copy area;;
    s) grimblast copy screen;;
    e) grimblast copysave area $temp_screenshot && swappy -f $temp_screenshot;;
    m) grimblast copy output;;
  esac
done

rm "$temp_screenshot"
