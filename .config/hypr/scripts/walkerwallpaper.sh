#!/bin/bash
Sel=$(find -L "/home/crispy/Documents/tagstudio/wallpapers/" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \))

while IFS= read -r path; do
    echo "label=$path;exec=swww img $path;image=$path"
done <<< "$Sel"
