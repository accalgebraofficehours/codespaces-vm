# Use official Arch Linux image
FROM archlinux:latest

# Install XFCE, VNC, and vital dependencies (Removed 'novnc')
RUN pacman -Syu --noconfirm \
    base-devel git xfce4 xfce4-goodies \
    tigervnc python-numpy xorg-server-xvfb \
    dbus xorg-server

# Create the user and give sudo permissions
RUN useradd -m -s /bin/bash archuser && \
    echo "archuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER archuser
WORKDIR /home/archuser
