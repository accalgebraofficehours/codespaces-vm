#!/bin/bash


sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm xfce4 xfce4-goodies tigervnc chromium xorg-server-xvfb dbus xterm git



if [ ! -d "noVNC" ]; then
    git clone https://github.com/novnc/noVNC
fi

chmod +x start.sh
chmod +x kill.sh

echo
echo
echo
echo -e "\n\n✅ Arch Linux Setup Complete! Start by running ./start.sh"
