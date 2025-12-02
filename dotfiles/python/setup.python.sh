#!/bin/bash

# Python Setup Script
# Install uv and other Python tools

set -e

source "$(dirname "$0")/../../lib.sh" 2>/dev/null || {
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
    log_error() { echo "[ERROR] $1"; }
}

install_uv() {
    log_info "Installing uv..."

    # Install uv
    if ! curl -LsSf https://astral.sh/uv/install.sh | sh; then
        log_error "Failed to install uv. Please check your internet connection and try again."
        exit 1
    fi

    log_info "uv installation completed"

    # Add uv to PATH if not already present
    if ! grep -q "\.cargo/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    fi

    log_info "uv is ready to use!"
    log_info "You can now use uv to manage Python projects and dependencies"
}

# Execute if sourced or run directly
install_uv
