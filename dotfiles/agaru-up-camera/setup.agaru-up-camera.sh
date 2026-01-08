#!/bin/bash

set -e

source "$(dirname "$0")/../../lib.sh" 2>/dev/null || {
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; }
}

# Clone agaru-up-camera repository to /home/hal446
log_info "Cloning agaru-up-camera repository to /home/hal446..."
REPO_URL="https://github.com/ohs25-2-misoten/agaru-up-camera.git"
REPO_PATH="/home/hal446/agaru-up-camera"

if [ -d "$REPO_PATH" ]; then
    log_warn "Repository already exists at $REPO_PATH. Pulling latest changes..."
    cd "$REPO_PATH"
    git pull origin main
    uv sync
else
    git clone "$REPO_URL" "$REPO_PATH"
    cd "$REPO_PATH"
    uv sync
    log_info "Repository cloned successfully to $REPO_PATH"
fi

log_info "agaru-up-camera setup completed"

