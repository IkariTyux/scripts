#!/bin/bash

if [ "$USER" != root ]; 
then 
  sudo "$0" "$@"
  exit
fi

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
Distro=$(grep '^ID=' /etc/os-release | cut -d= -f2)

# Install the required packages
case $Distro in

  arch|manjaro)
    pacman -Syy qemu-full virt-manager virt-viewer dnsmasq bridge-utils libguestfs ebtables vde2 openbsd-netcat 
    ;;

  debian|ubuntu|linux-mint)
    apt update &&  apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    ;;

  pop)
    apt update &&  apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
    ;;

  rhel|fedora)
    dnf update &&  dnf install qemu-kvm libvirt virt-install bridge-utils libvirt-devel virt-top libguestfs-tools guestfs-tools virt-manager -y  
    ;;
esac

# Start Libvirtd
systemctl enable --now libvirtd.service
echo 'unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"' |  tee -a /etc/libvirt/libvirtd.conf > /dev/null
usermod -aG libvirt $USER
systemctl enable --now libvirtd.service

# Finish
if [ $? = 0 ]
  then echo -e "\033[32m Successfully installed KVM.\033[0m"
  else echo -e "\033[033m Error in Installation, see logs at $LogFile.\033[0m"
fi
