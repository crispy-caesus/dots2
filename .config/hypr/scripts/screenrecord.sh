#!/bin/bash

# Stop wf-recorder if it's already running
if pgrep -x "wf-recorder" > /dev/null; then
  pkill -INT -x wf-recorder
  notify-send -h string:wf-recorder:record -t 1000 "Finished Recording"
  exit 0
fi

flags=""
fileextention="mp4"
output="-o DP-3"  # Default output

# Parse options using getopts
while getopts "ae:lo:" flag; do  # ':' for options with arguments
  case "${flag}" in
    a) flags="${flags} -a=$(pactl get-default-sink).monitor";;            # Append the -a flag
    e) fileextention=${OPTARG};;            # Set the file format from -f option
    l) flags="${flags} -b 5000k -r 30";;        # sets lower bitrate and framerate
    o) output="-o ${OPTARG}";;           # Set the output device from -o option
    *) echo "Invalid option"; exit 1;;   # Handle invalid options
  esac
done

# Add the output flag to the flags
flags="${flags} ${output}"

# Debugging: Print the constructed flags
echo "Flags: ${flags}"
echo "File format: ${fileformat}"


# Debugging: Print the full command that will be executed
echo "Running command: wf-recorder -f ~/Videos/recording.${fileformat} -y ${flags}"

# Start wf-recorder with the specified format, flags, and output
wf-recorder -f ~/Videos/recording.${fileextention} -y ${flags}
