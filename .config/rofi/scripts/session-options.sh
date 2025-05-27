#!/bin/bash

CHOICE=$(echo -e "󰌾   Lock\n󰗽   Logout\n󰂠   Suspend\n   Reboot\n󰚦   Power Off" | rofi -dmenu -i -p "Session Options" -normal-window)

case "$CHOICE" in
    "󰌾   Lock")
        hyprlock &
        ;;
    "󰗽   Logout")
        hyprctl dispatch exit
        ;;
    "󰂠   Suspend")
        systemctl suspend
        ;;
    "   Reboot")
        systemctl reboot
        ;;
    "󰚦   Power Off")
        systemctl poweroff
        ;;
    *)
        exit 1
        ;;
esac
