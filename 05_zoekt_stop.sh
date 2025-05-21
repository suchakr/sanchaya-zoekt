#!/bin/bash
# 05_zoekt_stop.sh - Stop the zoekt services

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Stopping Zoekt services...${NC}"

# Function to check if any zoekt containers are still running
check_containers_stopped() {
    running_containers=$(docker compose ps --status running -q 2>/dev/null)
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
    # Stop the services with default config
    docker compose down
fi

# Verify all containers are stopped
if check_containers_stopped; then
    echo -e "${GREEN}✅ All Zoekt services stopped successfully${NC}"
else
    echo -e "${RED}⚠️ Some containers are still running:${NC}"
    docker compose ps --format "table {{.Names}}\t{{.Status}}"
    echo -e "${YELLOW}You may need to stop them manually with:${NC}"
fi
