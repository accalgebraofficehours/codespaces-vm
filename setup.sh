#!/bin/bash
# =====================================
# setup.sh — One-time Arch Codespaces VNC setup
# =====================================
set -e
set -x  # show commands as they run

# -----------------------
# Install required packages
# -----------------------
sudo pacman -Sy --noconfirm python tigervnc xfce4 xfce4-goodies git
# pipx for websockify (no system pip install required)
sudo pacman -Sy --noconfirm python-pipx
pipx install websockify

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
echo "You will now set the VNC password (required for start.sh):"
vncpasswd $HOME/.config/vnc/passwd

# -----------------------
# Create TigerVNC config file
# -----------------------
cat << EOF > $HOME/.config/vnc/config
geometry=1280x800
depth=24
rfbauth=$HOME/.config/vnc/passwd
xstartup=$HOME/.config/vnc/xstartup
EOF
chmod 600 $HOME/.config/vnc/config

echo "✅ One-time setup complete. You can now run ./start.sh to start VNC + noVNC."
