#!/bin/bash

CHOICE=$(echo -e "   Charge Settings\n󱐋   Power Profiles\n󰐥   Session Options" | rofi -dmenu -i -p "Battery Options" -normal-window)

case "$CHOICE" in
    "   Charge Settings"*)
        bash ~/.config/rofi/scripts/charge-settings.sh
        ;;
    "󱐋   Power Profiles"*)
        bash ~/.config/rofi/scripts/power-profiles.sh
        ;;
    "󰐥   Session Options"*)
        bash ~/.config/rofi/scripts/session-options.sh
        ;;
    *)
        exit 1
        ;;
esac
