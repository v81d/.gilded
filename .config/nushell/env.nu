##############################################
# SHELL CONFIGURATION ------------------------
##############################################


# Configuration
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

# PATH
$env.path ++= ["~/.local/bin"]

# Zoxide
zoxide init nushell --cmd cd | save -f ~/.zoxide.nu

