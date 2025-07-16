#!/usr/bin/env bash

wifi_list=$(nmcli -t -f active,ssid,security dev wifi list | sed '/^--/d')

# De-duplicate
unique_list=$(echo "$wifi_list" | awk -F: '
{
  if ($2 != "") {
    if (!seen[$2]++) {
      data[$2] = $0
    }
    if ($1 == "yes") {
      data[$2] = $0
    }
  }
}
END {
  for (k in data) print data[k]
}')

connected_entry=""
other_entries=""

while IFS=: read -r active ssid security; do
  [[ -z "$ssid" ]] && continue

  if [[ "$security" == "--" || "$security" == "" ]]; then
    lock=""
  else
    lock=""
  fi

  line="<span font='JetBrainsMono Nerd Font Mono'>$lock </span>$ssid"

  if [[ "$active" == "yes" ]]; then
    connected_entry="<span color='#dbaf63'><b>$line</b></span>"
  else
    other_entries+="$line\n"
  fi
done <<< "$unique_list"

# Combine with connected
if [[ -n "$connected_entry" ]]; then
  formatted_list="$connected_entry\n$other_entries"
else
  formatted_list="$other_entries"
fi

# Wi-Fi toggle
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
    toggle="<span font='JetBrainsMono Nerd Font Mono'>󰤮 </span>Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
    toggle="<span font='JetBrainsMono Nerd Font Mono'>󰤨 </span>Enable Wi-Fi"
fi

if [[ -n "$formatted_list" ]]; then
    menu_input="$toggle\n${formatted_list%\\n}"
else
    menu_input="$toggle"
fi

# Show menu
chosen_network=$(echo -e "$menu_input" | uniq -u | rofi -dmenu -markup-rows -i -selected-row 1 -p "Network Options" -normal-window)
read -r chosen_id <<< "$(echo "$chosen_network" | sed -E 's/<[^>]+>//g' | sed 's/^[^ ]* //' | xargs)"

# Actions
if [ -z "$chosen_network" ]; then
    exit
elif [ "$chosen_network" = "$toggle" ]; then
    if [[ "$connected" =~ "enabled" ]]; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
else
    success_message="You are now connected to the Wi-Fi network \"$chosen_id.\""
    saved_connections=$(nmcli -g NAME connection)
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
    else
        wifi_password=$(rofi -dmenu -p "Password" -normal-window)

        # Try to connect and capture output and exit code
        connect_output=$(nmcli device wifi connect "$chosen_id" password "$wifi_password" 2>&1)
        exit_code=$?
        
        if [[ $exit_code -eq 0 ]] && echo "$connect_output" | grep -q "successfully"; then
          notify-send "Connection Established" "$success_message"
        else
          notify-send -u critical "Connection Failed" "Could not connect to \"$chosen_id\".\n$connect_output"
        fi
    fi
fi

