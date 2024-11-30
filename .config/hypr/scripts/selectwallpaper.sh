#!/bin/bash

last_wallpapers_file="$HOME/.config/hypr/lastwallpapers.txt"

# Select a wallpaper using rofi
select_wallpaper() {
	wallpapers=$(find "$HOME/Documents/tagstudio/wallpapers" -type f)

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

	# Check if there is an active wallpaper on the monitor and unload it
	current_wallpaper_path=$(hyprctl hyprpaper listactive | grep "$monitor" | awk -F ' = ' '{print $2}')
	if [[ -n $current_wallpaper_path ]]; then
		hyprctl hyprpaper unload "$current_wallpaper_path"
	fi

	# Preload and set the new wallpaper
	hyprctl hyprpaper preload "$wallpaper_path"

    for monitor in $(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }'); do
        hyprctl hyprpaper wallpaper "$monitor,$wallpaper_path"
    done

	# Save the active wallpapers to a file
	hyprctl hyprpaper listactive >"$last_wallpapers_file"
}

# Load last saved wallpapers from the file
load_last_wallpapers() {
	if [[ -f "$last_wallpapers_file" ]]; then
		available_monitors=$(hyprctl -j monitors | jq -r '.[].name')

		sleep 0.1 # Wait for hyprpaper to load

		# Load wallpapers from the file
		while IFS=' = ' read -r monitor wallpaper_path; do
			if [[ -n $monitor && -n $wallpaper_path && -f "$wallpaper_path" ]]; then
				# Check if the monitor exists
				if echo "$available_monitors" | grep -q "$monitor"; then
					# Preload and set the wallpaper if the monitor exists
					hyprctl hyprpaper preload "$wallpaper_path"
					hyprctl hyprpaper wallpaper "$monitor,$wallpaper_path"
				else
					echo "Monitor $monitor is not connected."
				fi
			fi
		done <"$last_wallpapers_file"

		# Get the list of active wallpapers
		active_paths=$(hyprctl hyprpaper listactive | awk -F ' = ' '{print $2}')
		# Get the list of loaded wallpapers
		loaded_paths=$(hyprctl hyprpaper listloaded | awk -F ' = ' '{print $2}')

		# Unload wallpapers that are loaded but not active
		for loaded in $loaded_paths; do
			if ! echo "$active_paths" | grep -q "$loaded"; then
				hyprctl hyprpaper unload "$loaded"
			fi
		done
	else
		echo "Last wallpapers file not found."
	fi
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
			set_wallpaper "$selected_monitor" "$HOME/Documents/tagstudio/wallpapers/$selected_wallpaper"
		fi
	fi
	;;
esac
