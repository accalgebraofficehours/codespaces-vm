# Use official Arch Linux image
FROM archlinux:latest

# Install XFCE, VNC, and noVNC dependencies
RUN pacman -Syu --noconfirm \
    base-devel git xfce4 xfce4-goodies \
    tigervnc novnc python-numpy xorg-server-xvfb

# Codespaces requires a non-root user for best results
RUN useradd -m -s /bin/bash archuser && \
    echo "archuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER archuser
