#!/bin/bash

# Python Setup Script
# Install uv and other Python tools

set -e

source "$(dirname "$0")/../../lib.sh" 2>/dev/null || {
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
}

install_uv() {
    log_info "Installing uv..."

    # Install uv
    curl -LsSf https://astral.sh/uv/install.sh | sh

    log_info "uv installation completed"
    uv --version

    # Add uv to PATH if not already present
    if ! grep -q "\.cargo/bin" ~/.bashrc; then
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    fi

    log_info "uv is ready to use!"
    log_info "You can now use uv to manage Python projects and dependencies"
}

# Execute if sourced or run directly
install_uv "$@"
