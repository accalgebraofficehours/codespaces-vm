#!/bin/bash
# =====================================
# start.sh — Arch Codespaces VNC + noVNC
# =====================================
set -e
set -x  # show commands for debugging

# -----------------------
# Variables
# -----------------------
REPO_DIR="$(pwd)"
LOGFILE="$REPO_DIR/novnc-start.log"
VNC_DISPLAY=${1:-1}       # allow optional display override
VNC_PORT=$((5900 + VNC_DISPLAY))
NOVNC_PORT=$((6080 + VNC_DISPLAY - 1))   # 6080 for :1, 6081 for :2, etc.
XSTARTUP="$REPO_DIR/utils/xfce-xstartup"

# -----------------------
# Logging helpers
# -----------------------
echo "===== Starting Arch Codespaces VNC =====" | tee "$LOGFILE"
echo "REPO_DIR: $REPO_DIR" | tee -a "$LOGFILE"
echo "VNC_DISPLAY: $VNC_DISPLAY" | tee -a "$LOGFILE"
echo "VNC_PORT: $VNC_PORT" | tee -a "$LOGFILE"
echo "NOVNC_PORT: $NOVNC_PORT" | tee -a "$LOGFILE"

# -----------------------
# Kill old sessions
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

# Start novnc_proxy pointing to the correct VNC port
./utils/novnc_proxy --vnc 127.0.0.1:"$VNC_PORT" --listen "$NOVNC_PORT" >> "$LOGFILE" 2>&1 &

echo "VNC + noVNC running. Connect via Codespaces forwarded port $NOVNC_PORT." | tee -a "$LOGFILE"
echo "========================================" | tee -a "$LOGFILE"
