#!/bin/bash

if [ "$USER" != root ]; 
then 
  sudo "$0" "$@"
  exit
fi

# Define Variables
Distro=$(grep '^ID=' /etc/os-release | cut -d= -f2)
TLauncherLocation="/usr/local/bin"

# Getting the jar file ready
curl -Ls https://dl2.tlauncher.org/f.php?f=files%2Fstarter-core-1.24-v1.jar -o tlauncher.jar 
mv tlauncher.jar $TLauncherLocation/tlauncher.jar

# Installing Java
case $Distro in
  arch|manjaro)
    pacman -Sy
    pacman -S --noconfirm jre-openjdk
    ;;
  debian|ubuntu|linuxmint|pop)
    apt update 
    apt install default-jre -y
    ;;
  fedora|rhel)
    dnf update
    dnf install java-11-openjdk.x86_64 -y
    ;;
  *)
    echo "Your distro isn't supported yet."
    exit
    ;;
esac

# Copy .desktop file
curl https://raw.githubusercontent.com/IkariTyux/scripts/main/files/minecraft.desktop > /usr/share/applications/minecraft.desktop

# Finish
if [ $? -eq 0 ]
then
  echo -e "\033[32m Successfully Installed TLauncher.\033[0m"
  notify-send --icon=terminal --app-name=Bash 'TLauncher installed' 'TLauncher has been installed, check your app menu'
else
  echo -e "\033[033m Error in Installation.\033[0m"
fi
