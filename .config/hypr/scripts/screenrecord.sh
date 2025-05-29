#!/bin/bash

# Stop wf-recorder if it's already running
if pgrep -x "wl-screenrec" > /dev/null; then
    pkill -INT -x wl-screenrec
    notify-send -h string:wl-screenrec:record -t 1000 "Finished Recording"
    exit 0
fi

flags=""
fileextention="mkv"
output="-o DP-2"  # Default output

# Parse options using getopts
while getopts "ae:lo:" flag; do  # ':' for options with arguments
    case "${flag}" in
        a) flags="${flags} --audio --audio-device="$(pactl get-default-sink).monitor"";;            # Append the -a flag
        e) fileextention=${OPTARG};;            # Set the file format from -f option
        l) flags="${flags} -b 1MB --ffmpeg-encoder h264_vaapi --ffmpeg-encoder-options \"crf=28,preset=veryfast\""        # sets lower bitrate and framerate
            fileextention="mp4";;
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
echo "Running command: wl-screenrec -f ~/Videos/recording.${fileformat} ${flags}"

# Start wf-recorder with the specified format, flags, and output
wl-screenrec -f ~/Videos/recording.${fileextention} ${flags}
