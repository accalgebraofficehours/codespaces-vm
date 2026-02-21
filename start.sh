#!/bin/bash
# =====================================
# start.sh — Arch Codespaces VNC + noVNC (Shared Desktop, password-safe)
# =====================================
set -e
set -x  # show commands for debugging

# -----------------------
# Variables
# -----------------------
REPO_DIR="$(pwd)"
LOGFILE="$REPO_DIR/novnc-start.log"
VNC_DISPLAY=1           # always :1 for shared session
VNC_PORT=$((5900 + VNC_DISPLAY))
NOVNC_PORT=6080         # fixed for all clients
XSTARTUP="$HOME/.config/vnc/xstartup"

# -----------------------
# Logging helpers
# -----------------------
echo "===== Starting Shared Arch Codespaces VNC =====" | tee "$LOGFILE"
echo "REPO_DIR: $REPO_DIR" | tee -a "$LOGFILE"
echo "VNC_DISPLAY: $VNC_DISPLAY" | tee -a "$LOGFILE"
echo "VNC_PORT: $VNC_PORT" | tee -a "$LOGFILE"
echo "NOVNC_PORT: $NOVNC_PORT" | tee -a "$LOGFILE"

# -----------------------
# Kill old session
# -----------------------
vncserver -kill ":$VNC_DISPLAY" || true
pkill -f novnc_proxy || true
rm -f "$HOME/.vnc/*.log"

# -----------------------
# Ensure VNC directories exist
# -----------------------
mkdir -p "$HOME/.vnc"
chmod 700 "$HOME/.vnc"

# -----------------------
# Check password exists
# -----------------------
if [ ! -f "$HOME/.vnc/passwd" ]; then
    echo "ERROR: VNC password not found. Please run 'vncpasswd' once manually before starting." | tee -a "$LOGFILE"
    exit 1
fi

# -----------------------
# Start VNC server
# -----------------------
echo "Starting TigerVNC on display :$VNC_DISPLAY..." | tee -a "$LOGFILE"
vncserver ":$VNC_DISPLAY" -geometry 1280x800 -depth 24 -xstartup "$XSTARTUP" >> "$LOGFILE" 2>&1 || {
    echo "VNC FAILED — check log" | tee -a "$LOGFILE"
    cat "$LOGFILE"
    exit 1
}

# -----------------------
# Start noVNC
# -----------------------
echo "Starting noVNC on port $NOVNC_PORT..." | tee -a "$LOGFILE"
cd "$REPO_DIR/noVNC" || { echo "noVNC directory missing!" | tee -a "$LOGFILE"; exit 1; }

./utils/novnc_proxy --vnc 127.0.0.1:"$VNC_PORT" --listen "$NOVNC_PORT" >> "$LOGFILE" 2>&1 &

echo "Shared VNC + noVNC running. Connect via Codespaces forwarded port $NOVNC_PORT." | tee -a "$LOGFILE"
echo "========================================" | tee -a "$LOGFILE"
