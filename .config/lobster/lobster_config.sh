# This is an example configuration file for lobster. This configuration includes all of the defaults, which you can change to you likings. The script will behave the exact same if you remove all of the values present here.

lobster_editor=${VISUAL:-${EDITOR:-vim}}
player=mpv
download_dir="$PWD"
provider="Vidcloud"
history="true"
subs_language="english"
histfile="$HOME/.local/share/lobster/lobster_history.txt"
use_external_menu="false"
image_preview="true"
debug="false"
quiet_output="false"
preview_window_size=50%
ueberzug_x=$(($(tput cols) - 70))
ueberzug_y=$(($(tput lines) / 10))
ueberzug_max_width=100
ueberzug_max_height=100
discord="true"

download_video() {
  ffmpeg -loglevel error -stats -i "$1" -c copy "$3/$2".mp4
}
