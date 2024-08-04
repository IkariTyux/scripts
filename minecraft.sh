#!/bin/bash

if [ "$USER" != root ]; 
then 
  sudo "$0" "$@"
  exit
fi

# Define Variables
Distro=$(grep '^ID=' /etc/os-release | cut -d= -f2)
TLauncherLocation="/usr/local/bin"
TLauncherFile=$(basename *.jar)

# Getting the jar file ready
curl -L https://tlauncher.org/jar -o tmp.zip
unzip -j -o tmp.zip -d $TLauncherLocation
mv $TLauncherLocation/$TLauncherFile $TLauncherLocation/minecraft.jar
rm -f tmp.zip $TLauncherLocation/README-EN.txt $TLauncherLocation/README-RUS.txt

# Installing Java
case $Distro in
  arch|manjaro|endevouros)
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
  opensuse-leap|opensuse-tumbleweed)
    zypper --non-interactive install java-17-openjdk
      ;;
  *)
    echo "Your distro isn't supported yet."
      ;;
esac

# Copy .desktop file
curl https://raw.githubusercontent.com/IkariTyux/scripts/main/files/minecraft.desktop > /usr/share/applications/minecraft.desktop

# Finish
if [ $? -eq 0 ]
  then echo -e "\033[32m Successfully Installed TLauncher, you may now open it from your app launcher.\033[0m"
  else echo -e "\033[033m Error in Installation.\033[0m" && exit
fi
