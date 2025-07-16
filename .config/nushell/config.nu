##############################################
# ENVIRONMENT --------------------------------
##############################################


# Transient prompt
$env.TRANSIENT_PROMPT_COMMAND = "❯ "
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = "∙ "


##############################################
# ALIASES ------------------------------------
##############################################


alias cat = bat  # Use bat instead of cat
# zoxide aliased as cd (change directory) in env.nu


##############################################
# INITIALIZATIONS ----------------------------
##############################################


# Initialize Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Initialize Zoxide
source ~/.zoxide.nu

# Startup commands
clear
fastfetch

