#!/bin/bash

CHOICE=$(echo -e "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -i -p "Session Options" -normal-window)

case "$CHOICE" in
    "Lock")
        hyprlock &
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    *)
        exit 1
        ;;
esac
