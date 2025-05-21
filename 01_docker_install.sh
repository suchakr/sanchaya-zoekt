#!/bin/bash
# 01_docker_install.sh - Check and install Docker if needed

set -euo pipefail

echo "Stage 1: Checking Docker installation..."

if [ -f ./.checkpoints/01_docker_install.done ]; then
    echo "Stage 1 already completed."
    exit 0
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. You need to install Docker to continue."
    echo "Please visit https://docs.docker.com/get-docker/ to download and install Docker."
    echo "After installing Docker, run this script again."
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "Docker is installed but not running. Please start Docker and run this script again."
    exit 1
fi

echo "Docker is installed and running."

# Check if Docker Compose is installed
if ! docker compose version &> /dev/null; then
    echo "Docker Compose V2 is not available. You need Docker Compose V2 to continue."
    echo "Please update Docker to include Docker Compose V2."
    exit 1
fi

echo "Docker Compose V2 is available."

# Create checkpoint
mkdir -p ./.checkpoints
touch ./.checkpoints/01_docker_install.done
echo "✅ Stage 1: Docker installation check complete"
