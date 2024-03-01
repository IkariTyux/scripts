#!/bin/bash

figlet "KVM / QEMU" | lolcat

# Define Variables
Distro=$(cat /etc/os-release | grep -v BUILD_ID | grep ID | sed -s "s/ID=//g")
LogFile="/home/$USER/.kvm_install.log"
Date=$(date +"%Y-%m-%d - %H:%M:S")

## Check if Virtualisation is enabled 
VirtEnable=$(grep -Ec '(vmx|svm)' /proc/cpuinfo)
if [ $VirtEnable -gt 0 ]
  then echo -e "\033[32m Virtualisation is enabled\033[0m"
  else echo -e "\033[033m Virtualisation not enabled. Enable it in the BIOS\033[0m" && exit
fi

## Define Variables
Distro=$(cat /etc/os-release | grep -v BUILD_ID | grep ID | sed -s "s/ID=//g")


# Install the requiered packages
case $Distro in

  arch)
    sudo pacman -Syy qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat --noconfirm
    ;;

  manjaro)
    sudo pacman -Syy qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat --noconfirm
    ;;

  endeavouros)
    sudo pacman -Syy qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat --noconfirm
    ;;

  debian)
    echo -n "unknown"
    ;;

  ubuntu)
    echo -n "unknown"
    ;;

  linuxmint)
    echo -n "unknown"
    ;;

  pop)
    sudo apt update && apt install
    ;;

  fedora)
    echo -n "unknown"
    ;;

  rhel)
    echo -n "unknown"
    ;;

  opensuse-tumbleweed)
    echo -n "unknown"
    ;;

  opensuse-tumbleweed)
    echo -n "unknown"
    ;;

esac


## Start Libvirtd
sudo systemctl enable --now libvirtd.service
sudo echo 'unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"' | sudo tee -a /etc/libvirt/libvirtd.conf > /dev/null
sudo usermod -aG libvirt $USER
sudo systemctl enable --now libvirtd.service

## Finish
if [ $? -eq 0 ]
  then echo -e "\033[32m Sucessfully installed KVM.\033[0m"
  else echo -e "\033[033m Error in Installation, see logs at $LogFile.\033[0m" && exit
fi
