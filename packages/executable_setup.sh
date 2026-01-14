#! /usr/bin/env bash

DIR=$(dirname "$0")
cd "$DIR"

. ../scripts/functions.sh

COMMENT=\#*

sudo -v

info "Installing Brewfile packages..."
brew bundle --file=$HOME/Brewfile
success "Finished installing Brewfile packages."