#!/bin/bash
# setup.sh - Setup script for Sanchaya Zoekt Search on macOS
# This script installs dependencies and prepares the environment for local development

set -e  # Exit on error

echo "===== Setting up Sanchaya Zoekt Search ====="

# Check if Go is installed
if ! command -v go &>/dev/null; then
    echo "Go is not installed. Installing Go using Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    brew install go
else
    echo "Go is already installed: $(go version)"
fi

# Check if Git is installed
if ! command -v git &>/dev/null; then
    echo "Git is not installed. Installing Git using Homebrew..."
    brew install git
else
    echo "Git is already installed: $(git --version)"
fi

# Install Zoekt
echo "Installing Zoekt..."
go install github.com/google/zoekt/cmd/zoekt-indexserver@latest
go install github.com/google/zoekt/cmd/zoekt-webserver@latest
go install github.com/google/zoekt/cmd/zoekt-git-index@latest

# Add Go bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
    echo "Adding $HOME/go/bin to PATH..."
    echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.zshrc
    export PATH="$PATH:$HOME/go/bin"
    echo "Please restart your terminal or run 'source ~/.zshrc' for the changes to take effect."
fi

# Create data directories
mkdir -p data/index data/repos

echo "===== Setup complete! ====="
echo "You can now run the local server with ./scripts/run_local.sh"
