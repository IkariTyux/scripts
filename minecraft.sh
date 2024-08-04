#!/bin/bash

# Define Variables
Distro=$(cat /etc/os-release | grep -v BUILD_ID | grep ID | sed -s "s/ID=//g")
TlauncherLocation="/home/$USER/.local/bin"
TLauncherFile=$(basename *.jar)

# Getting the jar file ready
download_minecraft () {
curl -s -L https://tlauncher.org/jar -o tmp.zip
unzip -j -o tmp.zip -d $TlauncherLocation > /dev/null
mv $TlauncherLocation/$TLauncherFile $TlauncherLocation/minecraft.jar
rm -f tmp.zip README-EN.txt README-RUS.txt
}
download_minecraft 2>> $LogFile

# Installing Java
case $Distro in
  arch|manjaro|endevouros)
    sudo pacman -Sy
    sudo pacman -S --noconfirm jre-openjdk
      ;;
  debian|ubuntu|linuxmint|pop)
    sudo apt update 
    sudo apt install default-jre -y
      ;;
  fedora|rhel)
    sudo dnf update 
    sudo dnf install java-11-openjdk.x86_64 -y
      ;;
  opensuse-leap|opensuse-tumbleweed)
    sudo zypper --non-interactive install java-17-openjdk
      ;;
  *)
    echo "Your distro isn't supported yet."
      ;;
esac

# Copy .desktop file
curl -s https://raw.githubusercontent.com/IkariTyux/scripts/main/files/minecraft.desktop > /home/$USER/.local/share/applications/minecraft.desktop

## Finish
if [ $? -eq 0 ]
  then echo -e "\033[32m Successfully Installed TLauncher, you may now open it from your app launcher.\033[0m"
  else echo -e "\033[033m Error in Installation.\033[0m" && exit
fi
