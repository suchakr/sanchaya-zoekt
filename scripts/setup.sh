#!/bin/bash
# setup.sh - Setup script for Sanchaya Zoekt Search on macOS
# This script installs dependencies and prepares the environment for local development

set -e  # Exit on error

# Default to Docker mode unless specified otherwise
MODE=${1:-docker}

echo "===== Setting up Sanchaya Zoekt Search (Mode: $MODE) ====="

if [[ "$MODE" == "docker" ]]; then
    echo "Setting up Docker environment..."
    
    # Check if Docker is installed
    if ! command -v docker &>/dev/null; then
        echo "Docker is not installed. Please install Docker Desktop for Mac:"
        echo "https://docs.docker.com/desktop/install/mac-install/"
        exit 1
    else
        echo "Docker is already installed: $(docker --version)"
    fi
    
    # Check if Docker Compose is installed
    if ! command -v docker-compose &>/dev/null; then
        echo "Docker Compose is not installed. This should be included with Docker Desktop."
        echo "If not, please visit: https://docs.docker.com/compose/install/"
        exit 1
    else
        echo "Docker Compose is already installed: $(docker-compose --version)"
    fi
    
    # Create data directories that will be mounted into the containers
    mkdir -p data/index data/repos
    
    echo "===== Docker setup complete! ====="
    echo "You can now run the local server with ./scripts/run_local.sh"
    echo "Note: The first run may take a few minutes to build the Docker images."
    
elif [[ "$MODE" == "direct" ]]; then
    echo "Setting up direct installation environment..."
    
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
    go install github.com/google/zoekt/cmd/zoekt-indexserver@main
    go install github.com/google/zoekt/cmd/zoekt-webserver@main
    go install github.com/google/zoekt/cmd/zoekt-git-index@main

    # Add Go bin to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
        echo "Adding $HOME/go/bin to PATH..."
        echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.zshrc
        export PATH="$PATH:$HOME/go/bin"
        echo "Please restart your terminal or run 'source ~/.zshrc' for the changes to take effect."
    fi

    # Create data directories
    mkdir -p data/index data/repos
    
    echo "===== Direct installation setup complete! ====="
    echo "You can now run the local server with ./scripts/run_local.sh direct"
else
    echo "Invalid mode: $MODE"
    echo "Usage: ./scripts/setup.sh [docker|direct]"
    echo "  docker  - Set up Docker environment (default)"
    echo "  direct  - Set up direct installation"
    exit 1
fi
