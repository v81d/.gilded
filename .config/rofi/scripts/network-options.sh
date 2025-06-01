#!/usr/bin/env bash

notify-send "Scanning" "Getting list of available Wi-Fi networks."
wifi_list=$(nmcli --fields "SSID" device wifi list | sed 1d | sed 's/^[ \t]*//')

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="<span font='JetBrainsMono Nerd Font Mono'>󰖪 </span>Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="<span font='JetBrainsMono Nerd Font Mono'>󰖩 </span>Enable Wi-Fi"
fi

chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -markup-rows -i -selected-row 1 -p "Network Options" -normal-window)
read -r chosen_id <<< "$chosen_network"

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "<span font='JetBrainsMono Nerd Font Mono'>󰖪 </span>Disable Wi-Fi" ]; then
	nmcli radio wifi off
elif [ "$chosen_network" = "<span font='JetBrainsMono Nerd Font Mono'>󰖩 </span>Enable Wi-Fi" ]; then
	nmcli radio wifi on
else
  	success_message="You are now connected to the Wi-Fi network \"$chosen_id.\""
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -p "Password" -normal-window)
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
    fi
fi
