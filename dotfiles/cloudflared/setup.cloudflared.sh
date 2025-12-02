#!/bin/bash

# Cloudflared Setup Script
# Install Cloudflare Tunnel (cloudflared) agent

set -e

source "$(dirname "$0")/../../lib.sh" 2>/dev/null || {
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; }
}

install_cloudflared() {
    log_info "Installing cloudflared..."

    # Check if cloudflared is already installed
    if command -v cloudflared &> /dev/null; then
        CURRENT_VERSION=$(cloudflared --version 2>&1 | head -n 1)
        log_info "cloudflared is already installed: $CURRENT_VERSION"
        return 0
    fi

    # Add Cloudflare GPG key
    log_info "Adding Cloudflare GPG key..."
    sudo mkdir -p --mode=0755 /usr/share/keyrings
    curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

    # Add Cloudflare repository to apt sources
    log_info "Adding Cloudflare repository..."
    echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

    # Install cloudflared
    log_info "Installing cloudflared package..."
    sudo apt-get update && sudo apt-get install -y cloudflared

    if command -v cloudflared &> /dev/null; then
        INSTALLED_VERSION=$(cloudflared --version 2>&1 | head -n 1)
        log_info "cloudflared installed successfully: $INSTALLED_VERSION"
    else
        log_error "cloudflared installation failed"
        return 1
    fi
}

# Execute setup function
install_cloudflared "$@"
