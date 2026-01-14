# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# Disable welcome message
$env.config.show_banner = false

# Set Editor
$env.config.buffer_editor = "zed"

# Set python, go etc, other GNU homebrew stuff is set on ~/.bash_profile
$env.path ++= [(brew --prefix python@3.14)/libexec/bin]
$env.path ++= [(brew --prefix python)/libexec/bin]
$env.path ++= ["~/go/bin"]
$env.path ++= ["~/.local/bin"]

# Completions
use ~/.config/nushell/completions/git-completions.nu *

# Path setup for init scripts
mkdir ($nu.data-dir | path join "vendor/autoload")

# Aliases
alias s = switcher
alias l = ls --all
alias c = clear
alias ll = ls -l
alias ltt = eza --tree --level=2 --long --icons --git
alias v = nvim
alias k = kubectl
alias pshell = overlay use .venv/bin/activate.nu
use ~/.config/nushell/aliases/git-aliases.nu *
use ~/.config/nushell/aliases/docker-aliases.nu *
source ~/.config/nushell/scripts/w.nu
use ~/.config/nushell/scripts/awse.nu *

# Disable poetry virtualenv prompth
$env.VIRTUAL_ENV_DISABLE_PROMPT = true

def --env mkcd [dir: string] {
  mkdir $dir
  cd $dir
}

# JJ
# Run this once if path setup for init scripts not working
jj util completion nushell | save -f ($nu.data-dir | path join "vendor/autoload/jj.nu")

# Zoxide
# Run this once if path setup for init scripts not working
# zoxide init nushell | save -f ~/.config/nushell/zoxide.nu
zoxide init nushell |  save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
# source ~/.config/nushell/zoxide.nu

# Atuin
# Run this once if path setup for init scripts not working
# atuin init nu | save -f ~/.config/nushell/atuin.nu
atuin init nu |  save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")
# source ~/.config/nushell/atuin.nu

# Starship Setup
# Run this once if path setup for init scripts not working
# starship init nu | save -f ~/.config/nushell/starship.nu
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
