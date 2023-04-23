#!/bin/bash

# Install dependencies
export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install -y build-essential stow git fzf ripgrep sqlite3 fd-find

rm -rf ~/.zshrc ~/.zprofile ~/.zlogin ~/.zlogout
mkdir ~/bin

# Setup dotfiles
git clone https://github.com/utkarsh-pro/dotfiles.git ~/dotfiles
pushd ~/dotfiles
make setup
popd

# Setup starship
curl -fsSL https://starship.rs/install.sh | sh -s -- -y
cat<<EOF >> ~/.config/starship.toml
[container]
format = '[\$symbol](bold green dimmed) '
EOF