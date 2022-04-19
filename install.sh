#!/bin/bash
THEME="construct-grub"
PREFIX="[construct-grub]"

construct_echo() {
    echo -e "$PREFIX $@"
}

#Check if run with priviliges
if [ $EUID -ne 0 ]
then
    construct_echo "This script requires sudo priviliges."
    exit
fi

if [[ ${1} =~ legacy ]]
then
    THEME="construct-legacy-grub"
fi

construct_echo ""
construct_echo "\t|--------------|"
construct_echo "\t|construct-grub|  by Olocool17"
construct_echo "\t|--------------|"
construct_echo ""
construct_echo "Theme to be installed: ${THEME}"

GRUB_DIR="grub"
GRUB_UPDATE=""
GRUB_CFG="/boot/grub/grub.cfg"

if [ -e /etc/os-release ]
then
    source /etc/os-release
    if [[ "$ID" =~ (debian|ubuntu|solus) || "$ID_LIKE" =~ (debian|ubuntu) ]]
    then
        GRUB_UPDATE="update-grub"
    elif [[ "$ID" =~ (arch|manjaro|gentoo) || "$ID_LIKE" =~ (archlinux|manjaro|gentoo) ]]
    then
        GRUB_UPDATE="grub-mkconfig -o ${GRUB_CFG}"
    elif [[ "$ID" =~ (centos|fedora|opensuse) || "$ID_LIKE" =~ (fedora|rhe1|suse) ]]
    then
        GRUB_CFG="/boot/grub2/grub.cfg"
        if [ -d /boot/efi/EFI/${ID}] ]
        then
            GRUB_CFG="/boot/efi/EFI/${ID}/grub.cfg"
        fi
        GRUB_DIR="grub2"
        GRUB_UPDATE="grub2-mkconfig -o ${GRUB_CFG}"
    fi
fi

construct_echo "Setting theme in GRUB config...."
sudo sed -i "\|^GRUB_THEME=.*|d" /etc/default/grub
sudo sed -i "\|^GRUB_TIMEOUT=.*|a GRUB_THEME=/boot/${GRUB_DIR}/themes/${THEME}/theme.txt" /etc/default/grub

construct_echo "Setting background in GRUB config...."
sudo sed -i "\|^GRUB_BACKGROUND=.*|d" /etc/default/grub
sudo sed -i "\|^GRUB_THEME.*|a GRUB_BACKGROUND=/boot/${GRUB_DIR}/themes/${THEME}/background.png" /etc/default/grub

construct_echo "Ensuring GRUB uses graphical output..."
sudo sed -i "s|^GRUB_TERMINAL|#GRUB_TERMINAL|g" /etc/default/grub

construct_echo "Removing previous installation of ${THEME} if it exists..."
sudo rm -r /boot/${GRUB_DIR}/themes/${THEME}

construct_echo "Making theme directory..."
sudo mkdir -p /boot/${GRUB_DIR}/themes/${THEME}

construct_echo "Copying ${THEME} theme to previously created directory..."
sudo cp -r ${THEME}-theme/* /boot/${GRUB_DIR}/themes/${THEME}

construct_echo "Generating grub.cfg..."
if [[ $GRUB_UPDATE ]]
then
    eval sudo $GRUB_UPDATE
else
    construct_echo "Could not detect distro. You will need to run grub-mkconfig manually to create your grub.cfg file."
    construct_echo "Common ways to do this:"
    construct_echo "- Debian/Ubuntu/Solus and derivatives : \`update-grub\` or \`grub-mkconfig -o /boot/grub/grub.cfg\`"
    construct_echo "- RHEL/CentOS/Fedora/SUSE and derivatives : \`grub2-mkconfig -o /boot/grub2/grub.cfg\`"
    construct_echo "- Arch/Gentoo and derivatives : \`grub-mkconfig -o /boot/grub/grub.cfg\`"
    construct_echo "Exiting..."
fi

construct_echo "Setting GRUB terminal background..."
sudo sed -i "\|^export theme|a background_image /${GRUB_DIR}/themes/${THEME}/background.png" ${GRUB_CFG}

construct_echo "Renaming Windows boot entry (if applicable)..."
sudo sed -i "s|'Windows Boot Manager[^']*|'Windows 10|g" ${GRUB_CFG}

construct_echo "Renaming EUFI Firmware boot entry (if applicable)..."
sudo sed -i "s|'UEFI Firmware Settings'|'UEFI Settings' --class efi|g" ${GRUB_CFG}

if [[ "$ID" =~ arch ]]
then
    construct_echo "Deleting Arch with fallback initrams entry..."
    sudo awk -i inplace "/Arch Linux, with Linux linux \(/,/}/ {next} {print}" ${GRUB_CFG}

    construct_echo "Renaming EUFI Firmware boot entry (if applicable)..."
    sudo sed -i "s|'Arch Linux, with Linux linux'|'Arch Linux'|g" ${GRUB_CFG}
fi

construct_echo "Adding shutdown menu entry..."
sudo sed -i "\|### END /etc/grub.d/40_custom ###|i menuentry 'Shutdown' --class shutdown {\n\thalt\n}" ${GRUB_CFG}

construct_echo "Installation complete!"
construct_echo "Exiting..."
exit