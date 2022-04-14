#!/bin/bash
THEME='construct-grub'
PREFIX='[construct-grub]'

construct_echo() {
    echo -e "$PREFIX $@"
}

#Check if run with priviliges
if [ $EUID -ne 0 ]
then
    construct_echo "This script requires sudo priviliges."
    exit
fi

construct_echo ""
construct_echo "\t|--------------|"
construct_echo "\t|construct-grub|  by Olocool17"
construct_echo "\t|--------------|"
construct_echo ""

GRUB_DIR=''
GRUB_UPDATE=''
GRUB_CFG=''

if [ -e /etc/os-release ]
then
    source /etc/os-release
    if [[ "$ID" =~ (debian|ubuntu|solus) || "$ID_LIKE" =~ (debian|ubuntu) ]]
    then
        GRUB_UPDATE='update-grub'
    elif [[ "$ID" =~ (arch|manjaro|gentoo || "$ID_LIKE" =~ (archlinux|manjaro|gentoo) ]]
    then
        GRUB_UPDATE='grub-mkconfig -o /boot/grub/grub.cfg'
    elif [[ "$ID" =~ (centos|fedora|opensuse) || "$ID_LIKE" =~ (fedora|rhe1|suse) ]]
    then
        GRUB_CFG="/boot/efi/EFI/${iID}.png"