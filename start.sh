#!/bin/bash

# 1. Update paths - Arch typically uses the absolute path to your workspace
WORKSPACE_DIR="/workspaces/$(basename $(pwd))"

# 2. Make sure your startup script is executable
sudo chmod +x "$WORKSPACE_DIR/utils/xfce-xstartup"

# 3. Kill previous VNC session
# Arch's TigerVNC is strict; we clean up the lock files too
vncserver -kill :1 2>/dev/null || true
sudo rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

# 4. Set VNC password
mkdir -p ~/.vnc
echo "password" | vncpasswd -f > ~/.vnc/passwd
sudo chmod 600 ~/.vnc/passwd

# 5. Start VNC server
# Note: Arch TigerVNC uses '-xstartup' differently, 
# so we point it directly to your file.
vncserver :1 -SecurityTypes VncAuth -geometry 1280x800 -depth 24 \
  -xstartup "$WORKSPACE_DIR/utils/xfce-xstartup" \
  -rfbport 5900 >> "$LOGFILE" 2>&1 || {
    echo "VNC FAILED — check log" | tee -a "$LOGFILE"
    exit 1
}
sleep 2

# 6. Start noVNC proxy
# Assuming you cloned noVNC into your root folder in setup.sh
cd "$WORKSPACE_DIR/noVNC" || exit
./utils/novnc_proxy --vnc 127.0.0.1:5900 --listen 0.0.0.0:6080
echo "VNC started. Go to ports tab and click on the globe on 6080"
