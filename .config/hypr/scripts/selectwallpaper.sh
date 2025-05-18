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

# Select a monitor using rofi
select_monitor() {
	monitors=$(hyprctl -j monitors | jq -r '.[].name')
	monitor_count=$(echo "$monitors" | wc -l)

	selected_monitor=$(for monitor in $monitors; do
		echo -en "$monitor\n"
	done | rofi -dmenu -p "MONITOR" -theme ~/.config/rofi/themes/wallpaper.rasi -no-show-icons -theme-str "window { width: 350px; } listview { lines: $monitor_count; columns: 1;}")

	echo "$selected_monitor"
}

# Set the wallpaper on a specified monitor
set_wallpaper() {
	local monitor=$1
	local wallpaper_path=$2

    matugen image $wallpaper_path

	# Save the active wallpapers to a file
	hyprctl hyprpaper listactive >"$last_wallpapers_file"
}

# Load last saved wallpapers from the file
load_last_wallpapers() {
    echo "Last wallpapers file not found."
}

# Argument handling
case "$1" in
--last)
	load_last_wallpapers
	;;

--path)
	if [[ -n $2 && -f $2 ]]; then
		selected_monitor=$(select_monitor)
		if [[ -n $selected_monitor ]]; then
			set_wallpaper "$selected_monitor" "$2"
		fi
	else
		echo "Invalid or missing wallpaper path."
	fi
	;;

*)
	selected_wallpaper=$(select_wallpaper)
	if [[ -n $selected_wallpaper ]]; then
		selected_monitor=$(select_monitor)
		if [[ -n $selected_monitor ]]; then
			set_wallpaper "$selected_monitor" "$HOME/Pictures/wallpapers/$selected_wallpaper"
		fi
	fi
	;;
esac
