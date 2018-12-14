#!/bin/bash
# About: Install and config ZSH and Oh-My-ZSH
#
# config-tools.sh
# Copyright (C) 2017 steve <steve@steve-pc>

DOTFILES_DIR="$HOME/.cache/dotfiles"
CUR_DATE=$(date +%Y-%m-%d)
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if ! type git > /dev/null; then
    printf "[Warning] Git is not installed, please install git.\n"
    exit 1
fi

#OS=$(lsb_release -si)
#
#case $OS in
#    'ManjaroLinux' )
#        echo "ManjaroLinux detected."
#        INSTALL='pacman -S'
#        ;;
#    'Ubuntu' )
#        echo "Ubuntu detected."
#        INSTALL='apt-get install'
#esac

read -p "Choose your OS: (a)ntergos, (u)buntu, (d)ifferent? " choice
printf "\n"
case $choice in
    a)
        echo "Antergos selected."
        INSTALL='pacman -S'
        POWERLINE='powerline powerline-fonts'
        ;;
    u)
        echo "Ubuntu selected."
        INSTALL='apt-get install'
        POWERLINE='fonts-powerline'
        ;;
    d)
        read -p "Please provide a package install command (e.g. apt-get install):" INSTALL
        printf "\n"
        ;;
esac

echo "Install ZSH..."
sudo "$INSTALL" zsh
if [[ ! -d ~/.oh-my-zsh/ ]]; then
    echo "Clone and install Oh-My-ZSH..."
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi

echo "Install ZSH theme..."
curl -sSL git.io/jovial | sudo bash -s $USER

echo "Install powerline fonts"
sudo "$INSTALL $POWERLINE"   

if [[ -d $DOTFILES_DIR ]]; then
    printf "[Warning] The dotfiles directory exists in the ~/.cache/ \n"
    read -p "Do you want to (b)ackup it, (r)emove it or doing (n)othing? " choice
    printf "\n"
    case $choice in
        b)
            printf "Backup the dotfile folder...\n"
            cp "$HOME/.cache/dotfiles/" "$HOME/.cache/dotfiles_backup_$CUR_DATE"
            rm -rf "$DOTFILES_DIR"
            ;;
        r)
            printf "Remove the dotfile folder...\n"
            rm -rf "$DOTFILES_DIR"
            ;;
        n)
            printf "Doing nothing...\n"
            ;;
    esac
fi

mkdir -p "$DOTFILES_DIR"
git clone https://github.com/whoolie53/systemconfig.git "$DOTFILES_DIR"

echo "Clone ZSH config files..."
cp -f "$DOTFILES_DIR/shell/zsh/.zshrc" ~/.zshrc
cp -f "$DOTFILES_DIR/shell/zsh/.zshenv" ~/.zshenv

echo "Copy zsh bullet-train theme"
cp -f "$DOTFILES_DIR/shell/zsh/bullet-train.zsh-theme" ~/.oh-my-zsh/themes/bullet-train.zsh-theme

echo "Copy custom aliases..."
cp -f "$DOTFILES_DIR/shell/.custom_aliases" ~/.custom_aliases
chmod +x ~/.custom_aliases

echo "Install ZSH completions plugin..."
git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

echo "Install ZSH autosuggestion plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

echo "Install ZSH syntax highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "Copy VPN config"
cp -f "$DOTFILES_DIR/vpn" ~/.vpn

printf "[CLEANUP] Remove dotfile directory.\n"
rm -rf "$DOTFILES_DIR"
