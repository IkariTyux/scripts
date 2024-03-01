#!/bin/bash

figlet "KVM / QEMU" | lolcat

## Define Variables
Distro=$(cat /etc/os-release | grep -v BUILD_ID | grep ID | sed -s "s/ID=//g")


