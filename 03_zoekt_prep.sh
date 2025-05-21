#!/bin/bash
# 03_zoekt_prep.sh - Prepare the zoekt deployment

set -euo pipefail

echo "Stage 3: Preparing Zoekt deployment..."

if [ -f ./.checkpoints/03_zoekt_prep.done ]; then
    echo "Stage 3 already completed."
    exit 0
fi

# Set the target directory, can be overridden with environment variable
TARGET_DIR=${ZOEKT_DATA_DIR:-/mnt/docker-data/sanchaya-zoekt-data}

SUDO=sudo

# Check if running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Running on macOS. Will use local directories."
    # On Mac, we'll use local directories
    TARGET_DIR="./data"
    SUDO=""
fi

# Ensure the directories exist
$SUDO mkdir -p "$TARGET_DIR/index"
$SUDO mkdir -p "$TARGET_DIR/repos"

# Set appropriate permissions - for local development on macOS, use 777 for maximum compatibility with Docker
echo "Setting permissions for $TARGET_DIR"
$SUDO chmod -R 777 "$TARGET_DIR"

# Create checkpoint
mkdir -p ./.checkpoints
touch ./.checkpoints/03_zoekt_prep.done
echo "✅ Stage 3: Zoekt preparation complete"
