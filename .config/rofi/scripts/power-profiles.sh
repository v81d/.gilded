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

OPTIONS="$(get_option performance "󰠠   Performance")
$(get_option balanced "󱪈   Balanced")
$(get_option power-saver "   Power Saver")"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "Power Profiles" -normal-window)

case "$CHOICE" in
    "󰠠   Performance"*)
        powerprofilesctl set performance
        ;;
    "   Balanced"*)
        powerprofilesctl set balanced
        ;;
    "   Power Saver"*)
        powerprofilesctl set power-saver
        ;;
    *)
        exit 1
        ;;
esac
