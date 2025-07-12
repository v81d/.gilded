#!/bin/bash

CHOICE=$(echo -e "<span font='JetBrainsMono Nerd Font Mono'>󰌾 </span>Lock\n<span font='JetBrainsMono Nerd Font Mono'>󰗽 </span>Log Out\n<span font='JetBrainsMono Nerd Font Mono'>󰂠 </span>Suspend\n<span font='JetBrainsMono Nerd Font Mono'> </span>Reboot\n<span font='JetBrainsMono Nerd Font Mono'>󰚦 </span>Power Off" | rofi -dmenu -markup-rows -i -p "Session Options" -normal-window)

case "$CHOICE" in
    "<span font='JetBrainsMono Nerd Font Mono'>󰌾 </span>Lock")
        hyprlock &
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'>󰗽 </span>Log Out")
        hyprctl dispatch exit
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'>󰂠 </span>Suspend")
        systemctl suspend
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'> </span>Reboot")
        systemctl reboot
        ;;
    "<span font='JetBrainsMono Nerd Font Mono'>󰚦 </span>Power Off")
        systemctl poweroff
        ;;
    *)
        exit 1
        ;;
esac
