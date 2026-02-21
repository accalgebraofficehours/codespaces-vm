#!/bin/bash


sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm xfce4 xfce4-goodies tigervnc chromium xorg-server-xvfb dbus xterm git
sudo pacman -S --noconfirm python-websockify



if [ ! -d "noVNC" ]; then
    git clone https://github.com/novnc/noVNC
fi

chmod +x /utils/kill.sh
echo "Made kill executable"
chmod +x start.sh
echo "Made start executable"


echo
echo
echo
echo -e "\n\n✅ Arch Linux Setup Complete! Setup by following ts document: https://bit.ly/vnc-setup"
echo

