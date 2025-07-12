# Environment
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.path ++= ["~/.local/bin"]

# Startup
clear
fastfetch

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
