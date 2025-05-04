
# ✨ .gilded

A collection of my personal dotfiles and configurations for a sleek and minimalistic Linux desktop using [Hyprland](https://hyprland.org/). Inspired by Gruvbox and Twilight.

![Desktop Screenshot](./screenshots/1.png)
![Rofi App Launcher Screenshot](./screenshots/2.png)
![Rofi Charge Menu Launcher Screenshot](./screenshots/2.png)

## 🛠️ Installation

### Prerequisites

Before installing these dotfiles, check for the packages below. Of course, you do **not** need to use the exact same set of packages; however, if you choose to exclude some of these packages, you must modify the configuration files to align with your setup.

| Package                              | Description                                                          |
| -------------------------------------| ---------------------------------------------------------------------|
| dunst                                | A lightweight notification daemon.                                   |
| hyprland                             | A Wayland-based tiling window manager.                               |
| kitty                                | A fast GPU-based terminal emulator.                                  |
| rofi                                 | A window switcher, run dialog, ssh-launcher and dmenu replacement.   |
| waybar                               | A highly customizable Wayland bar.                                   |
| lxqt-policykit (or anything similar) | A GUI policy kit authentification agent.                             |
| hyprpaper                            | A wallpaper utility for Hyprland.                                    |
| brightnessctl                        | A brightness reader and controller for Linux systems.                |
| slurp                                | A tool to select a region in a Wayland compositor.                   |
| grim                                 | A tool to grab images from a Wayland compositor.                     |
| fastfetch                            | A tool for fetching and displaying system information in a terminal. |

**\* A GUI policy kit authentification agent is required ONLY if you want to use the Rofi charge limit menu. You can use any other agent you prefer. If you do NOT use a policy kit agent, make sure to adjust the necessary settings in `hyprland.conf`.**

For my setup, I used the **Adwaita** fonts (for most of the setup), the **Nerd** fonts (for symbols and icons), and **Noto** fonts (to display other characters). You can choose to either install those or configure the fonts in the configuration files to your desires.

I also used the [Gruvbox Plus Icon Pack by SylEleuth](https://github.com/SylEleuth/gruvbox-plus-icon-pack). **If you choose to use another icon pack, adjust the section below in `hyprland.conf` to ensure that your icons are being displayed correctly in the notifications.** If you DO choose to use this icon pack, make sure that it is plaecd in `~/.local/share/icons`.

```conf
# Laptop multimedia keys for volume and LCD brightness
bindel = , XF86AudioRaiseVolume, exec, bash -c 'ICON=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-audio-volume-muted.svg || echo ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-audio-volume-high.svg); wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+; VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '"'"'{print int($2 * 100)}'"'"'); FILLED=$((VOL / 10)); EMPTY=$((10 - FILLED)); BAR=""; for i in $(seq 1 $FILLED); do BAR+="█"; done; for i in $(seq 1 $EMPTY); do BAR+="░"; done; dunstify -r 9993 -t 1000 -i "$ICON" "Volume" "$BAR $VOL%"'
bindel = , XF86AudioLowerVolume, exec, bash -c 'ICON=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-audio-volume-muted.svg || echo ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-audio-volume-medium.svg); wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-; VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '"'"'{print int($2 * 100)}'"'"'); FILLED=$((VOL / 10)); EMPTY=$((10 - FILLED)); BAR=""; for i in $(seq 1 $FILLED); do BAR+="█"; done; for i in $(seq 1 $EMPTY); do BAR+="░"; done; dunstify -r 9993 -t 1000 -i "$ICON" "Volume" "$BAR $VOL%"'
bindel = , XF86AudioMute, exec, bash -c 'MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "Unmuted" || echo "Muted"); ICON=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-audio-volume-high.svg || echo ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-audio-volume-muted.svg); dunstify -r 9993 -t 1000 -i "$ICON" "Volume" "$MUTED"; wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'
bindel = , XF86MonBrightnessUp, exec, bash -c 'brightnessctl set 2%+; VAL=$(brightnessctl get); MAX=$(brightnessctl max); PERC=$((VAL * 100 / MAX)); FILLED=$((PERC / 10)); EMPTY=$((10 - FILLED)); BAR=""; for i in $(seq 1 $FILLED); do BAR+="█"; done; for i in $(seq 1 $EMPTY); do BAR+="░"; done; dunstify -r 9994 -t 1000 -i ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-display-brightness.svg "Brightness" "$BAR $PERC%"'
bindel = , XF86MonBrightnessDown, exec, bash -c 'brightnessctl set 2%-; VAL=$(brightnessctl get); MAX=$(brightnessctl max); PERC=$((VAL * 100 / MAX)); FILLED=$((PERC / 10)); EMPTY=$((10 - FILLED)); BAR=""; for i in $(seq 1 $FILLED); do BAR+="█"; done; for i in $(seq 1 $EMPTY); do BAR+="░"; done; dunstify -r 9994 -t 1000 -i ~/.local/share/icons/Gruvbox-Plus-Dark/status/48/notification-display-brightness.svg "Brightness" "$BAR $PERC%"'
```

### Manual Install

1. Clone this repository and open it locally.

```bash
git clone https://github.com/v81d/.gilded.git ~/gilded
cd ~/gilded
```

2. Backup your current dotfiles if necessary (optional).

```bash
mkdir -p ~/.config/.backup
cp -r ~/.config/* ~/.config/.backup/
```

3. Install any necessary fonts, themes, or icons mentioned above.

4. Copy the configuration files from the repository to the `~/.config` folder. Create it if it does not exist yet.

```bash
cp -r ./.config/* ~/.config/
```

5. Reboot your system to apply the changes.

```bash
sudo reboot
```

6. Thoroughly review your configuration files and ensure that there are no errors.

## 🔋 Battery Charge Threshold (Integration with Rofi)

I included this service here in case anyone would like to use it. Below are the instructions to install.

### Installation

Make sure you are already using the `systemd` init system. This service will automatically set the battery charge threshold to a specified value when the system boots up.

Follow these steps in the `~/.gilded` directory you created earlier.

1. Copy the service file and configuration.

```bash
sudo cp ./etc/systemd/system/battery-charge-threshold.service /etc/systemd/system/
sudo cp ./etc/default/battery_charge_threshold /etc/default/
```

2. Edit the configuration file to set your preferred charge threshold.

```bash
sudo nano /etc/default/battery_charge_threshold
```

3. Enable and start the service.

```bash
sudo systemctl enable --now battery-charge-threshold.service
```

4. Verify it's working.

```bash
cat /sys/class/power_supply/BAT0/charge_control_end_threshold
```

> **Note**: This feature requires kernel support for battery charge thresholds and may not work on all hardware. Make sure the battery path is correct. Adjust any scripts if necessary.
