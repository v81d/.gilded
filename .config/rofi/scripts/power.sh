#!/bin/bash

CHOICE=$(echo -e "Logout\nSuspend\nReboot\nShutdown" | rofi -dmenu -i -p "Power" -normal-window)

case "$CHOICE" in
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
