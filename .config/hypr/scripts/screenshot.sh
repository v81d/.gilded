#!/bin/bash
mkdir -p "$HOME/Pictures/Screenshots"
geometry=$(slurp -b 00000080 -c 00000000 -s 00000000 | tr -d "\n")
filename="Screenshot From $(date +"%Y-%m-%d %H-%M-%S").png"
filepath="$HOME/Pictures/Screenshots/$filename"
grim -g "$geometry" "$filepath" && wl-copy < "$filepath" && notify-send -i camera-photo "Screenshot" "The screenshot has been saved and copied to the clipboard."
