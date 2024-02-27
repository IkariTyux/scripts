#!/bin/bash

figlet Minecraft | lolcat

# Define Variables
Distro=$(cat /etc/os-release | grep -v BUILD_ID | grep ID | sed -s "s/ID=//g")
LogFile="/home/$USER/.minecraft_install.log"
TlauncherLocation="/home/$USER/.apps"
TlauncherURL="https://tlauncher.org/jar"
TLauncherFile=$(basename *.jar)
Date=$(date +"%Y-%m-%d - %H:%M:S")

# Add new line to log
echo "\

$Date\

" >> $LogFile

# Geting the jar file ready
download_minecraft () {
curl https://tlauncher.org/jar -L --output TLauncher.zip
unzip -o TLauncher.zip > /dev/null
mv $TLauncherFile $TlauncherLocation/minecraft.jar
rm -f TLauncher.zip README-EN.txt README-RUS.txt
}
download_minecraft 2>> $LogFile

# Installing Java
if [ "$Distro" = "arch" ]
  then sudo pacman -Syy --noconfirm jre-openjdk 2>> $LogFile
elif [ "$Distro" = "debian" ]
  then sudo apt update && apt install default-jre -y 2>> $LogFile
elif [ "$Distro" = "fedora" ]
  then sudo dnf update && dnf install java-11-openjdk.x86_64 -y 2>> $LogFile
elif [ "$Distro" = "suse" ]
  then sudo zypperzypper --non-interactive install java-17-openjdk 2>> $LogFile
 else echo "This distro isn't supported"
fi

# Copy .desktop file
cp minecraft.desktop /home/$USER/.local/share/applications/minecraft.desktop

## Finish
if [ $? -eq 0 ]
  then echo -e "\033[32m Sucessfully Installed TLauncher, you may now open it from your app launcher.\033[0m"
  else echo -e "\033[033m Error in Installation, see logs at $LogFile.\033[0m" && exit
fi
