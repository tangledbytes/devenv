#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install -y stow fzf ripgrep sqlite3 fd-find

rm -rf ~/.zshrc ~/.zprofile ~/.zlogin ~/.zlogout
mkdir ~/bin

curl -fsSL https://starship.rs/install.sh | sh -s -- -y
