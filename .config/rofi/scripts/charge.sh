#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT0/charge_control_end_threshold"
CONFIG="/etc/default/battery_charge_threshold"

if [ ! -f "$BAT_PATH" ]; then
    notify-send -u critical "Battery Error" "Battery control file not found!"
    exit 1
fi

CURRENT=$(cat "$BAT_PATH" 2>/dev/null || echo "Unknown")

CHOICE=$(echo -e "No Limit (Normal) - Current: $CURRENT%\nLimit to 80% (Extended Lifespan)\nLimit to 60% (Maximum Health)" | rofi -dmenu -i -p "Battery Charge Limit" -normal-window)

case "$CHOICE" in
    "No Limit (Normal)"*)
        pkexec sh -c "echo 100 > '$BAT_PATH' && sed -i '/^CHARGE_THRESHOLD=/c\\CHARGE_THRESHOLD=100' '$CONFIG'" && \
        notify-send "Battery Limit Removed" "Charging will now go up to 100%."
        ;;
    "Limit to 80% (Extended Lifespan)")
        pkexec sh -c "echo 80 > '$BAT_PATH' && sed -i '/^CHARGE_THRESHOLD=/c\\CHARGE_THRESHOLD=80' '$CONFIG'" && \
        notify-send "Battery Limit Set" "Charging capped at 80% for extended lifespan."
        ;;
    "Limit to 60% (Maximum Health)")
        pkexec sh -c "echo 60 > '$BAT_PATH' && sed -i '/^CHARGE_THRESHOLD=/c\\CHARGE_THRESHOLD=60' '$CONFIG'" && \
        notify-send "Battery Limit Set" "Charging capped at 60% for maximum health."
        ;;
    *)
        exit 1
        ;;
esac
