#!/bin/bash

# This script runs after the container is created.
# The 'set -e' command ensures that the script will exit immediately if a command fails.
set -e

echo "Configuring Rust toolchain..."
if command -v rustup >/dev/null 2>&1; then
    rustup update stable
    rustup default stable
    rustup component add rustfmt clippy rust-analyzer rust-src
fi

if [[ -f Cargo.toml ]]; then
    cargo check
fi

if [[ -x .shared/tools/scripts/configure-subtree.sh ]]; then
    .shared/tools/scripts/configure-subtree.sh
fi

if [[ -x .shared/devcontainer/post-create.sh ]]; then
    .shared/devcontainer/post-create.sh
fi