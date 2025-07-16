#!/bin/bash

CHOICE=$(echo -e "<span font='JetBrainsMono Nerd Font Mono'> </span>Charge Settings\n<span font='JetBrainsMono Nerd Font Mono'>󱐋 </span>Power Profiles\n<span font='JetBrainsMono Nerd Font Mono'>󰐥 </span>Session Options" | rofi -dmenu -markup-rows -i -p "Battery Options" -normal-window)

case "$CHOICE" in
    "<span font='JetBrainsMono Nerd Font Mono'> </span>Charge Settings"*)
        bash ~/.config/rofi/scripts/charge-settings.sh
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'>󱐋 </span>Power Profiles"*)
        bash ~/.config/rofi/scripts/power-profiles.sh
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'>󰐥 </span>Session Options"*)
        bash ~/.config/rofi/scripts/session-options.sh
        ;;
    *)
        exit 1
        ;;
esac
