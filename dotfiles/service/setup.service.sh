#!/bin/bash

set -e

source "$(dirname "$0")/../../lib.sh" 2>/dev/null || {
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
    log_error() { echo "[ERROR] $1"; }
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEMD_DIR="/etc/systemd/system"

# Service files to set up
SERVICE_FILES=(
    "agaru-up-camera-rec.service"
    "agaru-up-camera-api.service"
)

log_info "Setting up systemd services..."

for service_file in "${SERVICE_FILES[@]}"; do
    source_path="${SCRIPT_DIR}/${service_file}"
    dest_path="${SYSTEMD_DIR}/${service_file}"

    if [ ! -f "$source_path" ]; then
        log_warn "Service file not found: $source_path"
        continue
    fi

    log_info "Creating symlink for $service_file..."
    if [ -L "$dest_path" ] || [ -f "$dest_path" ]; then
        log_info "Removing existing $dest_path..."
        sudo rm -f "$dest_path"
    fi

    sudo ln -s "$source_path" "$dest_path"
    log_info "Created symlink: $source_path -> $dest_path"
done

# Reload systemd daemon to recognize new service files
log_info "Reloading systemd daemon..."
sudo systemctl daemon-reload

for service_file in "${SERVICE_FILES[@]}"; do
    source_path="${SCRIPT_DIR}/${service_file}"

    if [ ! -f "$source_path" ]; then
        continue
    fi

    # Enable the service
    log_info "Enabling service: $service_file..."
    sudo systemctl enable "$service_file"

    # Start the service
    log_info "Starting service: $service_file..."
    sudo systemctl start "$service_file"

    log_info "✓ $service_file setup complete"
done

log_info "All services setup complete!"
