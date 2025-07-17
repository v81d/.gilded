##############################################
# ENVIRONMENT --------------------------------
##############################################


# TRANSIENT PROMPT
$env.TRANSIENT_PROMPT_COMMAND = "❯ "
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = "∙ "


##############################################
# ALIASES ------------------------------------
##############################################


# REPLACEMENT COMMANDS
alias cat = bat  # Use bat instead of cat

# COMMON USE
alias grubup = sudo grub-mkconfig -o /boot/grub/grub.cfg
alias fixpacman = sudo rm /var/lib/pacman/db.lck
alias tarnow = tar -acf 
alias untar = tar -zxvf 
alias wget = wget -c

# PACKAGE MANAGEMENT
alias update = sudo pacman -Syu
alias cleanup = sudo pacman -Rns (pacman -Qtdq)


##############################################
# INITIALIZATIONS ----------------------------
##############################################


# INITIALIZE STARSHIP
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# INITIALIZE ZOXIDE
source ~/.zoxide.nu

# STARTUP COMMANDS
clear
fastfetch

