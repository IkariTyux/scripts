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
# Check Distro
Distro=$(cat /etc/os-release | grep -v BUILD_ID | grep ID | sed -s "s/ID=//g")

# Install the required packages
case $Distro in

  arch)
    sudo pacman -Syy qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat 
    ;;

  manjaro)
    sudo pacman -Syy qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat --noconfirm
    ;;

  endeavouros)
    sudo pacman -Syy qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat --noconfirm
    ;;

  debian)
    sudo apt update && sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    ;;

  ubuntu)
    sudo apt update && sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    ;;

  linuxmint)
    sudo apt update && sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    ;;

  pop)
    sudo apt update && sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    ;;

  fedora)
    sudo dnf update && sudo dnf install qemu-kvm libvirt virt-install bridge-utils libvirt-devel virt-top libguestfs-tools guestfs-tools virt-manager -y  
    ;;

  rhel)
    sudo dnf update && sudo dnf install qemu-kvm libvirt virt-install bridge-utils libvirt-devel virt-top libguestfs-tools guestfs-tools virt-manager -y  
    ;;

  opensuse-leap)
    echo -n "opensuse-leap"
    ;;

  opensuse-tumbleweed)
    echo -n "opensuse-tumbleweed"
    ;;
esac

# Start Libvirtd
sudo systemctl enable --now libvirtd.service
sudo echo 'unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"' | sudo tee -a /etc/libvirt/libvirtd.conf > /dev/null
sudo usermod -aG libvirt $USER
sudo systemctl enable --now libvirtd.service

# Finish
if [ $? -eq 0 ]
  then echo -e "\033[32m Successfully installed KVM.\033[0m"
  else echo -e "\033[033m Error in Installation, see logs at $LogFile.\033[0m" && exit
fi
