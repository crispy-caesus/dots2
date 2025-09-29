#!/bin/bash

last_wallpapers_file="$HOME/.config/hypr/lastwallpapers.txt"

# Select a wallpaper using rofi
select_wallpaper() {
	wallpapers=$(find "$HOME/Pictures/wallpapers" -type f)

	#selected_wallpaper=$(for a in $wallpapers; do
	selected_wallpaper=$(echo "$wallpapers" | while IFS= read -r a; do
    echo -en "${a##*/}\0icon\x1f$a\n"
	done | PREVIEW=true rofi -dmenu -i -p "WALLPAPER" -theme ~/.config/rofi/themes/wallpaper.rasi)

	echo "$selected_wallpaper"
}

# Set the wallpaper on a specified monitor
set_wallpaper() {
	local wallpaper_path=$1

    #matugen image $wallpaper_path
    swww img $wallpaper_path
}

selected_wallpaper=$(select_wallpaper)
if [[ -n $selected_wallpaper ]]; then
    set_wallpaper "$HOME/Pictures/wallpapers/$selected_wallpaper"
fi
