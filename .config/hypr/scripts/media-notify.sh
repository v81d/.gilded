#!/bin/bash

volume_notif_id_file="/tmp/media_notify_volume"
brightness_notif_id_file="/tmp/media_notify_backlight"

volume_step=0.02
brightness_step=4
max_volume=1.00
notification_timeout=1500
download_media_art=true
show_media_art=true
show_media_in_volume_indicator=true

function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -Po '[0-9.]+'
}

function get_mute {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "muted"
}

function get_brightness {
    brightnessctl g | awk '{print int($1)}'
}

function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    vol_percent=$(printf "%.0f" "$(echo "$volume * 100" | bc -l)")
    
    if [ "$vol_percent" -eq 0 ] || [ "$mute" == "muted" ]; then
        volume_icon="󰝟 "
    elif [ "$vol_percent" -lt 50 ]; then
        volume_icon="󰖀 "
    else
        volume_icon="󰕾 "
    fi
}

function get_brightness_icon {
    brightness_icon="󰃟 "
}

function get_media_art {
    url=$(playerctl -f "{{mpris:artUrl}}" metadata)
    
    if [[ $url == "file://"* ]]; then
        media_art="${url/file:\/\//}"
    elif [[ $url == "http://"* || $url == "https://"* ]] && [[ $download_media_art == "true" ]]; then
        filename="$(echo $url | sed "s/.*\///")"
        if [ ! -f "/tmp/$filename" ]; then
            wget -O "/tmp/$filename" "$url"
        fi
        media_art="/tmp/$filename"
    else
        media_art=""
    fi
}

function show_volume_notif {
    volume=$(get_volume)
    vol_percent=$(printf "%.0f" "$(echo "$volume * 100" | bc -l)")
    mute=$(get_mute)
    get_volume_icon

    notif_id=$(cat "$volume_notif_id_file" 2>/dev/null || echo 0)

    if [[ $show_media_in_volume_indicator == "true" ]]; then
        artist=$(playerctl metadata artist 2>/dev/null)
        title=$(playerctl metadata title 2>/dev/null)
        
        if [[ -n "$artist" && -n "$title" ]]; then
            current_media="$artist – $title"
        elif [[ -n "$title" ]]; then
            current_media="$title"
        else
            current_media=""
        fi

        if [[ $show_media_art == "true" ]]; then
            get_media_art
        fi

        new_id=$(notify-send --print-id -t $notification_timeout -a "Volume" --replace-id="$notif_id" -h int:value:$vol_percent -i "$media_art" "$volume_icon $vol_percent%" "$current_media")
    else
        new_id=$(notify-send --print-id -t $notification_timeout -a "Volume" --replace-id="$notif_id" -h int:value:$vol_percent "$volume_icon $vol_percent%")
    fi

    echo "$new_id" > "$volume_notif_id_file"
}

function show_brightness_notif {
    brightness=$(brightnessctl g)
    max_brightness=$(brightnessctl m)
    percent=$(printf "%.0f" "$(echo "$brightness / $max_brightness * 100" | bc -l)")
    get_brightness_icon

    notif_id=$(cat "$brightness_notif_id_file" 2>/dev/null || echo 0)

    new_id=$(notify-send --print-id -t $notification_timeout -a "Backlight" --replace-id="$notif_id" -h int:value:$percent "$brightness_icon $percent%")

    echo "$new_id" > "$brightness_notif_id_file"
}

case $1 in
    volume_up)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        current_volume=$(get_volume)
        new_volume=$(echo "$current_volume + $volume_step" | bc)
        if (( $(echo "$new_volume > $max_volume" | bc -l) )); then
            new_volume=$max_volume
        fi
        wpctl set-volume @DEFAULT_AUDIO_SINK@ $new_volume
        show_volume_notif
        ;;

    volume_down)
        current_volume=$(get_volume)
        if (( $(echo "$current_volume <= $volume_step" | bc -l) )); then
            new_volume=0.0
        else
            new_volume=$(printf "%.2f" "$(echo "$current_volume - $volume_step" | bc -l)")
        fi
        wpctl set-volume @DEFAULT_AUDIO_SINK@ $new_volume
        show_volume_notif
        ;;
    
    volume_mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        show_volume_notif
        ;;

    brightness_up)
        brightnessctl set +$brightness_step%
        show_brightness_notif
        ;;

    brightness_down)
        current_brightness=$(brightnessctl g)
        max_brightness=$(brightnessctl m)
        percent=$(printf "%.0f" "$(echo "$current_brightness / $max_brightness * 100" | bc -l)")

        if (( percent <= brightness_step )); then
            brightnessctl set 0%
        else
            brightnessctl set ${brightness_step}%-
        fi
        show_brightness_notif
        ;;

    next_media)
        playerctl next
        ;;

    prev_media)
        playerctl previous
        ;;

    play_pause)
        playerctl play-pause
        ;;
esac
