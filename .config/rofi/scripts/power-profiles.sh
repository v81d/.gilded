#!/bin/bash

CURRENT=$(powerprofilesctl get)

# Append a checkmark to the current profile
get_option() {
    local PROFILE_NAME="$1"
    local DISPLAY_NAME="$2"
    if [[ "$CURRENT" == "$PROFILE_NAME" ]]; then
        echo "$DISPLAY_NAME  󰄬"
    else
        echo "$DISPLAY_NAME"
    fi
}

OPTIONS="$(get_option performance "<span font='JetBrainsMono Nerd Font Mono'>󰠠 </span>Performance")
$(get_option balanced "<span font='JetBrainsMono Nerd Font Mono'>󱪈 </span>Balanced")
$(get_option power-saver "<span font='JetBrainsMono Nerd Font Mono'> </span>Power Saver")"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -markup-rows -i -p "Power Profiles" -normal-window)

case "$CHOICE" in
    "<span font='JetBrainsMono Nerd Font Mono'>󰠠 </span>Performance"*)
        powerprofilesctl set performance
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'>󱪈 </span>Balanced"*)
        powerprofilesctl set balanced
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'> </span>Power Saver"*)
        powerprofilesctl set power-saver
        ;;
    *)
        exit 1
        ;;
esac
