#!/bin/bash

# SSH Configuration Setup Script
# Deploy SSH authorized_keys and server configuration via symbolic links

set -e

source "$(dirname "$0")/../../lib.sh" 2>/dev/null || {
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; }
}

setup_ssh_authorized_keys() {
    local SSH_DIR="$HOME/.ssh"
    local AUTHORIZED_KEYS_SRC="$(cd "$(dirname "$0")" && pwd)/authorized_keys"
    local AUTHORIZED_KEYS_DST="$SSH_DIR/authorized_keys"

    if [ ! -f "$AUTHORIZED_KEYS_SRC" ]; then
        log_warn "Authorized keys file not found: $AUTHORIZED_KEYS_SRC"
        return 1
    fi

    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    log_info "Setting up SSH authorized_keys..."

    # Backup existing authorized_keys if it exists and is not a symlink
    if [ -f "$AUTHORIZED_KEYS_DST" ] && [ ! -L "$AUTHORIZED_KEYS_DST" ]; then
        log_info "Backing up existing $AUTHORIZED_KEYS_DST to ${AUTHORIZED_KEYS_DST}.bak"
        mv "$AUTHORIZED_KEYS_DST" "${AUTHORIZED_KEYS_DST}.bak"
    fi

    # Remove existing symlink if it exists
    [ -L "$AUTHORIZED_KEYS_DST" ] && rm "$AUTHORIZED_KEYS_DST"

    # Create symlink
    ln -s "$AUTHORIZED_KEYS_SRC" "$AUTHORIZED_KEYS_DST"
    chmod 600 "$AUTHORIZED_KEYS_SRC"
    log_info "SSH authorized_keys symlink created: $AUTHORIZED_KEYS_DST -> $AUTHORIZED_KEYS_SRC"
}

setup_sshd_config() {
    local SSHD_CONF_SRC="$(cd "$(dirname "$0")" && pwd)/99-raspberry-pi.conf"
    local SSHD_CONF_DIR="/etc/ssh/sshd_config.d"
    local SSHD_CONF_DST="$SSHD_CONF_DIR/99-raspberry-pi.conf"

    if [ ! -f "$SSHD_CONF_SRC" ]; then
        log_warn "SSH server config file not found: $SSHD_CONF_SRC"
        return 1
    fi

    log_info "Setting up SSH server configuration..."

    # Create sshd_config.d directory if it doesn't exist
    if [ ! -d "$SSHD_CONF_DIR" ]; then
        log_info "Creating $SSHD_CONF_DIR..."
        sudo mkdir -p "$SSHD_CONF_DIR"
        sudo chmod 755 "$SSHD_CONF_DIR"
    fi

    # Backup existing custom conf if it exists and is not a symlink
    if [ -f "$SSHD_CONF_DST" ] && [ ! -L "$SSHD_CONF_DST" ]; then
        log_info "Backing up existing $SSHD_CONF_DST to ${SSHD_CONF_DST}.bak"
        sudo cp "$SSHD_CONF_DST" "${SSHD_CONF_DST}.bak"
    fi

    # Remove existing symlink if it exists
    [ -L "$SSHD_CONF_DST" ] && sudo rm "$SSHD_CONF_DST"

    # Create symlink
    sudo ln -s "$SSHD_CONF_SRC" "$SSHD_CONF_DST"
    log_info "SSH server config symlink created: $SSHD_CONF_DST -> $SSHD_CONF_SRC"

    # Validate sshd_config
    log_info "Validating sshd configuration..."
    if sudo sshd -t; then
        log_info "sshd configuration is valid"

        # Restart SSH service
        log_info "Restarting SSH service..."
        sudo systemctl restart ssh || sudo service ssh restart
        log_info "SSH service restarted"
    else
        log_error "sshd configuration validation failed"
        log_warn "Removing custom configuration to restore default behavior"
        sudo rm "$SSHD_CONF_DST"
        if [ -f "${SSHD_CONF_DST}.bak" ]; then
            log_info "Restoring backup..."
            sudo cp "${SSHD_CONF_DST}.bak" "$SSHD_CONF_DST"
        fi
        return 1
    fi
}

# Execute setup functions
setup_ssh_authorized_keys && setup_sshd_config
