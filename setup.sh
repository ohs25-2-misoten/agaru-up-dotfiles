#!/bin/bash

# Raspberry Pi Initial Setup Script
# This script sets up Raspberry Pi with dotfiles

set -e

# Source common library
source "$(dirname "$0")/lib.sh" 2>/dev/null || {
    # lib.shの読み込みに失敗した場合、フォールバックのログ関数を定義し、エラーメッセージを表示します。
    log_info()  { echo "[INFO] $1"; }
    log_warn()  { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; }
    log_error "Failed to source lib.sh. Fallback logging functions are being used."
}

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_SETUP="$DOTFILES_DIR/dotfiles/ssh/setup.ssh.sh"
PYTHON_SETUP="$DOTFILES_DIR/dotfiles/python/setup.python.sh"
CLOUDFLARED_SETUP="$DOTFILES_DIR/dotfiles/cloudflared/setup.cloudflared.sh"

# Update system
update_system() {
    log_info "Updating system packages..."
    sudo apt-get update
    sudo apt-get upgrade -y
}

# Install essential packages
install_essential_packages() {
    log_info "Installing essential packages..."
    sudo apt-get install -y \
        git \
        curl \
        wget \
        vim \
        nano \
        build-essential \
        python3
}

# Execute installation scripts
execute_install_scripts() {
    log_info "Executing setup scripts from dotfiles..."

    if [ -f "$PYTHON_SETUP" ]; then
        log_info "Running Python setup..."
        bash "$PYTHON_SETUP" || log_warn "Python setup encountered an issue"
    else
        log_warn "Python setup script not found: $PYTHON_SETUP"
    fi
}

# Setup SSH public key authentication via symbolic link
setup_ssh_public_key() {
    log_info "Setting up SSH configuration..."

    if [ -f "$SSH_SETUP" ]; then
        log_info "Running SSH setup..."
        bash "$SSH_SETUP" || log_warn "SSH setup encountered an issue"
    else
        log_warn "SSH setup script not found: $SSH_SETUP"
    fi
}

# Setup Cloudflared
setup_cloudflared() {
    log_info "Setting up Cloudflared..."

    if [ -f "$CLOUDFLARED_SETUP" ]; then
        log_info "Running Cloudflared setup..."
        bash "$CLOUDFLARED_SETUP" || log_warn "Cloudflared setup encountered an issue"
    else
        log_warn "Cloudflared setup script not found: $CLOUDFLARED_SETUP"
    fi
}

# Main
main() {
    log_info "Starting Raspberry Pi setup..."
    log_info "Dotfiles directory: $DOTFILES_DIR"

    # Ask for confirmation
    read -p "Do you want to continue with the setup? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_warn "Setup cancelled"
        exit 0
    fi

    # Execute setup steps
    update_system
    install_essential_packages
    execute_install_scripts
    setup_ssh_public_key
    setup_cloudflared

    log_info "Setup completed successfully!"
    log_info "Please restart your shell or run: source ~/.bashrc"
}

# Run main function
main "$@"
