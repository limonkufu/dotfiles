#! /usr/bin/env sh

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

info "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
else
    error "Failed to obtain sudo credentials."
fi

{{ if eq .chezmoi.os "darwin" }}
info "Installing XCode command line tools..."
if xcode-select --print-path &>/dev/null; then
    success "XCode command line tools already installed."
elif xcode-select --install &>/dev/null; then
    success "Finished installing XCode command line tools."
else
    error "Failed to install XCode command line tools."
fi

info "Installing Rosetta..."
sudo softwareupdate --install-rosetta
{{ else if eq .chezmoi.os "linux" }}
info "Checking for WSL..."
{{   if (.chezmoi.kernel.osrelease | lower | contains "microsoft") }}
info "WSL Detected!"
# Install common packages for WSL
{{ else }}
info "Not running under WSL. Skipping WSL-specific setup."
sudo apt update && sudo apt upgrade -y
sudo apt install -y software-properties-common
fi
{{ end }}

# Package control must be executed first in order for the rest to work
./packages/setup.sh

# Install every other setup.sh in the folders
find * -name "setup.sh" -not -wholename "packages*" | while read setup; do
    ./$setup
done

success "Finished installing Dotfiles"
