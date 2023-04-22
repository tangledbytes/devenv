#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install -y build-essential stow git fzf ripgrep sqlite3 fd-find
sudo chsh -s $(which zsh) $(whoami)

rm -rf ~/.zshrc ~/.zprofile ~/.zlogin ~/.zlogout
mkdir ~/bin
mkdir ~/dev

git clone https://github.com/utkarsh-pro/dotfiles.git ~/dev/dotfiles
pushd ~/dev/dotfiles
make setup
popd

curl -fsSL https://starship.rs/install.sh | sh -s -- -y