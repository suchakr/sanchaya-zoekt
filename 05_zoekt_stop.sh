#!/bin/bash
# 05_zoekt_stop.sh - Stop the zoekt services

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

docker_cmd() {
    if [[ "$(uname)" == "Darwin" ]]; then
        docker "$@"
    else
        sudo docker "$@"
    fi
}

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Stopping Zoekt services...${NC}"

# Function to check if any zoekt containers are still running
check_containers_stopped() {
    running_containers=$(docker_cmd compose ps --status running -q 2>/dev/null)
    if [ -z "$running_containers" ]; then
        return 0
    else
        return 1
    fi
}

# Check if running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Running on macOS. Using macOS-specific configuration..."
    # Stop services with macOS config
    docker compose -f docker-compose.yml -f docker-compose.mac.yml down
else
    # Use the same overlays as the production start command so the project is
    # addressed consistently, including its persistent data mounts.
    compose_files=(
        -f docker-compose.yml
        -f docker-compose.override.yml
        -f docker-compose.prod.yml
    )
    sudo env CADDYFILE=./config/Caddyfile.prod \
        docker compose "${compose_files[@]}" down
fi

# Verify all containers are stopped
if check_containers_stopped; then
    echo -e "${GREEN}✅ All Zoekt services stopped successfully${NC}"
else
    echo -e "${RED}⚠️ Some containers are still running:${NC}"
    docker_cmd compose ps --format "table {{.Names}}\t{{.Status}}"
    echo -e "${YELLOW}You may need to stop them manually with:${NC}"
fi
