#!/bin/bash
# =====================================
# start.sh — Arch Codespaces shared VNC + noVNC
# =====================================
set -e
set -x  # show commands for debugging

# -----------------------
# Variables
# -----------------------
REPO_DIR="$(pwd)"
LOGFILE="$REPO_DIR/novnc-start.log"
VNC_DISPLAY=1
VNC_PORT=$((5900 + VNC_DISPLAY))
NOVNC_PORT=6080

# -----------------------
# Logging
# -----------------------
echo "===== Starting Shared Arch Codespaces VNC =====" | tee "$LOGFILE"
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
# Start VNC server (uses config file automatically)
# -----------------------
echo "Starting TigerVNC on display :$VNC_DISPLAY..." | tee -a "$LOGFILE"
vncserver ":$VNC_DISPLAY" >> "$LOGFILE" 2>&1 || {
    echo "VNC FAILED — check log" | tee -a "$LOGFILE"
    cat "$LOGFILE"
    exit 1
}

# -----------------------
# Start noVNC
# -----------------------
echo "Starting noVNC on port $NOVNC_PORT..." | tee -a "$LOGFILE"
cd "$REPO_DIR/noVNC" || { echo "noVNC directory missing!" | tee -a "$LOGFILE"; exit 1; }

# Use pipx-installed websockify
pipx run websockify --web . "$NOVNC_PORT" 127.0.0.1:"$VNC_PORT" >> "$LOGFILE" 2>&1 &

echo "✅ Shared VNC + noVNC running. Connect via Codespaces forwarded port $NOVNC_PORT." | tee -a "$LOGFILE"
