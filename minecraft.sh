#!/bin/bash

figlet Minecraft | lolcat

# Define Variables
LogFile="/home/$USER/.minecraft_install.log"
TlauncherLocation="/home/$USER/.apps"
TlauncherURL="https://tlauncher.org/jar"
TLauncherFile=$(basename *.jar)
Date=$(date +"%Y-%m-%d - %H:%M:S")
## Get package manager
PS3='Enter the Name of your distro : '
select Distro in ArchLinux Debian 
do
    echo "$shuttle selected"
done

# Add new line to log
echo "\

$Date\

" >> $LogFile

# Geting the jar file ready
download_minecraft () {
curl https://tlauncher.org/jar -L --output TLauncher.zip
unzip -o TLauncher.zip
mv $TLauncherFile $TlauncherLocation/minecraft.jar
rm -f TLauncher.zip README-EN.txt README-RUS.txt
}
download_minecraft 2>> $LogFile

# Installing Java
install_java () {
if [ "$Distro" = "Arch" ]
  then sudo pacman -Syy jre-openjdk
elif [ "$Distro" = "Debian" ]
  then sudo apt update && apt install default-jre -y
elif [ "$Distro" = "Redhat" ]
  then sudo dnf update && dnf install java-11-openjdk.x86_64 -y
elif [ "$Distro" = "Suse" ]
  then sudo zypperzypper --non-interactive install java-17-openjdk
 else echo "This distro isn't supported"
fi
}
install_java 2>> $LogFile

## Finish
if [ $? -eq 0 ]
  then echo -e "\033[32m Sucessfully Installed Tlauncher\033[0m"
  else echo -e "\033[033m Error in Installation, see logs at $LogFile\033[0m" && exit
fi

