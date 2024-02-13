#! /usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

SOURCE="$(realpath -m .)"
DESTINATION="$(realpath -m ~/.config/fish)"

info "Setting up fish shell..."

set_fish_shell() {
    if grep --quiet fish <<< "$SHELL"; then
        success "Fish shell is already set up."
    else
        substep_info "Adding fish executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet "$(which fish)" /etc/shells; then
            substep_success "Fish executable already exists in /etc/shells."
        else
            if sudo bash -c "echo "$(which fish)" >> /etc/shells"; then
                substep_success "Fish executable added to /etc/shells."
            else
                substep_error "Failed adding Fish executable to /etc/shells."
                return 1
            fi
        fi
        substep_info "Changing shell to fish"
        if chsh -s "$(which fish)"; then
            substep_success "Changed shell to fish"
        else
            substep_error "Failed changing shell to fish"
            return 2
        fi
        substep_info "Running fish initial setup"
        fish -c "setup"
    fi
}

if set_fish_shell; then
    success "Successfully set up fish shell."
else
    error "Failed setting up fish shell."
fi

# Install fisher
info "Installing fisher and plugins"
read -p "Install fisher with 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher' in a new terminal"
cp fish_plugins $DESTINATION/fish_plugins
fisher update


info "Installing starship shell prompt"
curl -sS https://starship.rs/install.sh | sh
