#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install -y build-essential stow git fzf ripgrep sqlite3 fd-find

rm -rf ~/.zshrc ~/.zprofile ~/.zlogin ~/.zlogout
mkdir ~/bin

git clone https://github.com/utkarsh-pro/dotfiles.git /tmp/dotfiles
pushd /tmp/dotfiles
make setup
popd

curl -fsSL https://starship.rs/install.sh | sh -s -- -y