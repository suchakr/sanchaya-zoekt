#!/bin/bash
# 04_zoekt_start.sh - Start the zoekt services

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAX_RETRIES=10
RETRY_INTERVAL=5

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if a container is running
check_container() {
    local container_name=$1
    local retries=$2
    local interval=$3
    local counter=0
    
    echo -n "Waiting for $container_name to start "
    
    while [ $counter -lt $retries ]; do
        status=$(docker ps --filter "name=^/$container_name$" --format "{{.Status}}" 2>/dev/null)
        
        if [[ "$status" == *"Up"* ]] && [[ "$status" != *"Restarting"* ]]; then
            echo -e "\n${GREEN}$container_name is running!${NC}"
            return 0
        elif [[ "$status" == *"Restarting"* ]]; then
            echo -n "."
        elif [[ -z "$status" ]]; then
            echo -n "."
        else
            echo -n "."
        fi
        
        sleep $interval
        counter=$((counter + 1))
    done
    
    # Check one last time
    status=$(docker ps --filter "name=^/$container_name$" --format "{{.Status}}" 2>/dev/null)
    if [[ "$status" == *"Up"* ]] && [[ "$status" != *"Restarting"* ]]; then
        echo -e "\n${GREEN}$container_name is running!${NC}"
        return 0
    fi
    
    echo -e "\n${RED}Timed out waiting for $container_name to start!${NC}"
    return 1
}

# Function to print service status
print_service_status() {
    echo -e "\n${YELLOW}Service Status:${NC}"
    docker ps --filter "name=zoekt|caddy" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

echo -e "${YELLOW}Starting Zoekt services...${NC}"

# Check if running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Running on macOS. Using macOS-specific configuration..."
    # Start services with macOS config
    docker compose -f docker-compose.yml -f docker-compose.mac.yml up -d
else
    # Check if previous stages are complete
    if [ ! -f ./.checkpoints/03_zoekt_prep.done ]; then
        echo "Previous stages not completed. Please run the setup scripts first."
        exit 1
    fi
    
    # Start the services with the default config
    docker compose up -d
fi

# Check if containers are running
echo -e "${YELLOW}Verifying services...${NC}"
expected_containers=("zoekt-webserver" "caddy")
all_running=true

for container in "${expected_containers[@]}"; do
    if ! check_container "$container" $MAX_RETRIES $RETRY_INTERVAL; then
        all_running=false
    fi
done

if [ "$all_running" = true ]; then
    print_service_status
    echo -e "\n${GREEN}All services are running!${NC}"
    echo -e "You can access the web interface at ${YELLOW}http://localhost:6070${NC}"
    echo "To view logs: docker compose logs -f"
else
    print_service_status
    echo -e "\n${RED}Some services failed to start. Check docker logs for more information:${NC}"
    echo "docker logs zoekt-webserver"
    echo "docker logs caddy"
    exit 1
fi
