#!/bin/bash

# Git Configuration Setup Script
# Deploy git config via symbolic link

set -e

source "$(dirname "$0")/../../lib.sh" 2>/dev/null || {
    # Fallback logging functions
    log_info() { echo "[INFO] $1"; }
    log_warn() { echo "[WARN] $1"; }
}

setup_git_config() {
    local GIT_CONFIG_SRC="$(cd "$(dirname "$0")" && pwd)/gitconfig"
    local GIT_CONFIG_DST="$HOME/.gitconfig"

    if [ ! -f "$GIT_CONFIG_SRC" ]; then
        log_warn "Git config file not found: $GIT_CONFIG_SRC"
        return 1
    fi

    log_info "Setting up git config..."

    # Backup existing gitconfig if it exists and is not a symlink
    if [ -f "$GIT_CONFIG_DST" ] && [ ! -L "$GIT_CONFIG_DST" ]; then
        log_info "Backing up existing $GIT_CONFIG_DST to ${GIT_CONFIG_DST}.bak"
        mv "$GIT_CONFIG_DST" "${GIT_CONFIG_DST}.bak"
    fi

    # Remove existing symlink if it exists
    [ -L "$GIT_CONFIG_DST" ] && rm "$GIT_CONFIG_DST"

    # Create symlink
    ln -s "$GIT_CONFIG_SRC" "$GIT_CONFIG_DST"
    log_info "Git config symlink created: $GIT_CONFIG_DST -> $GIT_CONFIG_SRC"
}

# Execute if sourced or run directly
setup_git_config "$@"
