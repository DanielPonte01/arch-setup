#!/bin/bash
#
        echo "###############################################################################"
        echo "################## Arch-Setup "
        echo "###############################################################################"
        echo

#############################################   ArcoLinux repo and keys    "###############################################

sudo pacman -S wget --noconfirm --needed

echo "Getting the ArcoLinux keys from the ArcoLinux repo - report if link is broken"
sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-keyring-20251209-3-any.pkg.tar.zst -O /tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-keyring-20251209-3-any.pkg.tar.zst

echo "Getting the latest arcolinux mirrors file - report if link is broken"
sudo wget https://github.com/arcolinux/arcolinux_repo/raw/main/x86_64/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst -O /tmp/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst
sudo pacman -U --noconfirm --needed /tmp/arcolinux-mirrorlist-git-23.06-01-any.pkg.tar.zst

######################################################################################################################

if grep -q arcolinux_repo /etc/pacman.conf; then

	echo "ArcoLinux repos are already in /etc/pacman.conf"

else

echo '
#[arcolinux_repo_testing]
#SigLevel = PackageRequired DatabaseNever
#Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_3party]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist

[arcolinux_repo_xlarge]
SigLevel = PackageRequired DatabaseNever
Include = /etc/pacman.d/arcolinux-mirrorlist' | sudo tee --append /etc/pacman.conf

fi

sudo pacman -Syyu




installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

#####################################   Bluetooth       #################################################################

echo
tput setaf 3
echo "################################################################"
echo "################### Bluetooth"
echo "################################################################"
tput sgr0
echo

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package "$1" is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package "  $1
        echo "###############################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}


installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

if [ ! -f /usr/share/xsessions/plasma.desktop ]; then
  sudo pacman -S --noconfirm --needed blueberry
fi

sudo pacman -S --noconfirm --needed bluez
sudo pacman -S --noconfirm --needed bluez-libs
sudo pacman -S --noconfirm --needed bluez-utils

sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

if ! grep -q "load-module module-switch-on-connect" /etc/pulse/system.pa; then
    echo 'load-module module-switch-on-connect' | sudo tee --append /etc/pulse/system.pa
fi

if ! grep -q "load-module module-bluetooth-policy" /etc/pulse/system.pa; then
    echo 'load-module module-bluetooth-policy' | sudo tee --append /etc/pulse/system.pa
fi

if ! grep -q "load-module module-bluetooth-discover" /etc/pulse/system.pa; then
    echo 'load-module module-bluetooth-discover' | sudo tee --append /etc/pulse/system.pa
fi

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo




##################################################  CUPS    ################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

echo
tput setaf 3
echo "################################################################"
echo "################### cups"
echo "################################################################"
tput sgr0
echo

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package "$1" is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package "  $1
        echo "###############################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}


installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

sudo pacman -S --noconfirm --needed cups
sudo pacman -S --noconfirm --needed cups-pdf
sudo pacman -S --noconfirm --needed ghostscript
sudo pacman -S --noconfirm --needed gsfonts
sudo pacman -S --noconfirm --needed gutenprint
sudo pacman -S --noconfirm --needed gtk3-print-backends
sudo pacman -S --noconfirm --needed libcups
sudo pacman -S --noconfirm --needed system-config-printer
sudo pacman -S --noconfirm --needed sane
sudo pacman -S --noconfirm --needed simple-scan

sudo systemctl enable --now cups.service

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo


####################################################    Core        ##############################################################
#
sudo pacman -Syy

echo
tput setaf 2
echo "################################################################"
echo "################### Core software"
echo "################################################################"
tput sgr0
echo

#       Terminal

sudo pacman -S --noconfirm --needed alacritty
sudo pacman -S --noconfirm --needed alacritty-themes
#sudo pacman -S --noconfirm --needed kitty
#sudo pacman -S --noconfirm --needed neofetch

## Shell

sudo pacman -S --noconfirm --needed zsh
sudo pacman -S --noconfirm --needed zsh-completions
sudo pacman -S --noconfirm --needed zsh-syntax-highlighting

## Terminal-Utils

sudo pacman -S --noconfirm --needed network-manager-applet
sudo pacman -S --noconfirm --needed networkmanager-openvpn
#sudo pacman -S --noconfirm --needed nmtui


#       Firefox

sudo pacman -S --noconfirm --needed firefox
sudo pacman -S --noconfirm --needed w3m
#sudo pacman -S --noconfirm --needed lynx
sudo pacman -S --noconfirm --needed chromium

## Learning

sudo pacman -S --noconfirm --needed okular
#sudo pacman -S --noconfirm --needed evince
sudo pacman -S --noconfirm --needed foliate
yay -S --noconfirm --needed epy-ereader-git


## Img/video

#sudo pacman -S --noconfirm --needed spotify
sudo pacman -S --noconfirm --needed ncspot
sudo pacman -S --noconfirm --needed discord

## Torrent
sudo pacman -S --noconfirm --needed qbittorrent
#sudo pacman -S --noconfirm --needed transmission-cli

#   Utils
sudo pacman -S --noconfirm --needed arandr
sudo pacman -S --noconfirm --needed dmenu
sudo pacman -S --noconfirm --needed light
sudo pacman -S --noconfirm --needed gpick
sudo pacman -S --noconfirm --needed flameshot-git
sudo pacman -S --noconfirm --needed gitahead-bin
sudo pacman -S --noconfirm --needed pavucontrol
sudo pacman -S --noconfirm --needed ripgrep
sudo pacman -S --noconfirm --needed man-db
sudo pacman -S --noconfirm --needed man-pages
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed gzip
sudo pacman -S --noconfirm --needed p7zip
sudo pacman -S --noconfirm --needed unace
sudo pacman -S --noconfirm --needed unrar
sudo pacman -S --noconfirm --needed unzip
sudo pacman -S --noconfirm --needed sublime-text-4
sudo pacman -S --noconfirm --needed syncthing
sudo pacman -S --noconfirm --needed calcurse
if [ ! -f /usr/bin/duf ]; then
    sudo pacman -S --noconfirm --needed duf
fi

# Others
sudo pacman -S --noconfirm --needed noto-fonts
sudo pacman -S --noconfirm --needed font-manager
sudo pacman -S --noconfirm --needed adobe-source-sans-fonts
sudo pacman -S --noconfirm --needed arc-gtk-theme
sudo pacman -S --noconfirm --needed surfn-icons-git
#sudo pacman -S --noconfirm --needed bibata-cursor-theme-bin
#sudo pacman -S --noconfirm --needed sardi-icons
sudo pacman -S --noconfirm --needed awesome-terminal-fonts
sudo pacman -S --noconfirm --needed ttf-bitstream-vera
sudo pacman -S --noconfirm --needed ttf-dejavu
sudo pacman -S --noconfirm --needed ttf-droid
sudo pacman -S --noconfirm --needed ttf-hack
sudo pacman -S --noconfirm --needed ttf-inconsolata
sudo pacman -S --noconfirm --needed ttf-liberation
sudo pacman -S --noconfirm --needed ttf-roboto
sudo pacman -S --noconfirm --needed ttf-roboto-mono
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family



if [ ! -f /usr/share/xsessions/plasma.desktop ]; then
  sudo pacman -S --noconfirm --needed qt5ct
  sudo pacman -S --noconfirm --needed kvantum
fi


if [ -f /usr/share/xsessions/xfce.desktop ]; then

  echo
  tput setaf 2
  echo "################################################################"
  echo "################### Installing software for Xfce"
  echo "################################################################"
  tput sgr0
  echo

  sudo pacman -S --noconfirm --needed menulibre
  sudo pacman -S --noconfirm --needed mugshot
  sudo pacman -S --noconfirm --needed prot16-xfce4-terminal
  sudo pacman -S --noconfirm --needed tempus-themes-xfce4-terminal-git
  sudo pacman -S --noconfirm --needed xfce4-terminal-base16-colors-git

fi

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo



echo
tput setaf 6
echo "################################################################"
echo "################### PJE "
echo "################################################################"
tput sgr0
echo



sudo pacman -S --noconfirm --needed opensc
yay -S --noconfirm --needed safesignidentityclient
yay -S --noconfirm --needed pje-office
sudo systemctl enable --now pcscd.service





#############################################   Nvim config "###############################################


git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
