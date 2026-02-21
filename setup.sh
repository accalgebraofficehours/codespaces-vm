#!/bin/bash

set -e
set -x  # show commands for debugging

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm xfce4 xfce4-goodies tigervnc chromium xorg-server-xvfb dbus xterm git
pip install --user websockify


if [ ! -d "noVNC" ]; then
    git clone https://github.com/novnc/noVNC
fi

chmod +x /utils/kill.sh
echo "Made kill executable"
chmod +x start.sh
echo "Made start executable"



# -----------------------
# Create required folders
# -----------------------
mkdir -p $HOME/.config/vnc
mkdir -p $HOME/.vnc

# -----------------------
# Copy xstartup script
# -----------------------
cp utils/xfce-xstartup $HOME/.config/vnc/xstartup
chmod +x $HOME/.config/vnc/xstartup

# -----------------------
# Set VNC password (interactive)
# -----------------------
echo "Now you will set the VNC password (required for start.sh)"
vncpasswd $HOME/.config/vnc/passwd

echo "ok i think ts is complete follow bit.ly/setup-vnc for more instructions."
