#!/bin/bash
# 04_zoekt_start.sh - Start the zoekt services

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAX_RETRIES=10
RETRY_INTERVAL=5
cd "$SCRIPT_DIR"

case "$#" in
    0)
        BUILD=false
        ;;
    1)
        if [[ "$1" != "--build" ]]; then
            echo "Usage: $0 [--build]"
            exit 2
        fi
        BUILD=true
        ;;
    *)
        echo "Usage: $0 [--build]"
        exit 2
        ;;
esac

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

# Function to check if a container is running
check_container() {
    local container_name=$1
    local retries=$2
    local interval=$3
    local counter=0
    
    echo -n "Waiting for $container_name to start "
    
    while [ $counter -lt $retries ]; do
        status=$(docker_cmd ps --filter "name=^/$container_name$" --format "{{.Status}}" 2>/dev/null)
        
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
    status=$(docker_cmd ps --filter "name=^/$container_name$" --format "{{.Status}}" 2>/dev/null)
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
    docker_cmd ps --filter "name=zoekt|caddy" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

echo -e "${YELLOW}Starting Zoekt services...${NC}"

# Check if running on macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Running on macOS. Using macOS-specific configuration..."
    compose_files=(
        -f docker-compose.yml
        -f docker-compose.mac.yml
    )
    docker compose "${compose_files[@]}" config --quiet
    if [[ "$BUILD" == true ]]; then
        docker compose "${compose_files[@]}" up -d --build
    else
        docker compose "${compose_files[@]}" up -d
    fi
else
    # Check if previous stages are complete
    if [ ! -f ./.checkpoints/03_zoekt_prep.done ]; then
        echo "Previous stages not completed. Please run the setup scripts first."
        exit 1
    fi

    # The override keeps the index and repository cache on the persistent disk.
    # The production overlay publishes only the public HTTP/HTTPS ports.
    compose_files=(
        -f docker-compose.yml
        -f docker-compose.override.yml
        -f docker-compose.prod.yml
    )

    sudo env CADDYFILE=./config/Caddyfile.prod \
        docker compose "${compose_files[@]}" config --quiet
    if [[ "$BUILD" == true ]]; then
        sudo env CADDYFILE=./config/Caddyfile.prod \
            docker compose "${compose_files[@]}" up -d --build
    else
        sudo env CADDYFILE=./config/Caddyfile.prod \
            docker compose "${compose_files[@]}" up -d
    fi
fi

# Check if containers are running
echo -e "${YELLOW}Verifying services...${NC}"
expected_containers=("zoekt-webserver" "zoekt-caddy")
all_running=true

for container in "${expected_containers[@]}"; do
    if ! check_container "$container" $MAX_RETRIES $RETRY_INTERVAL; then
        all_running=false
    fi
done

if [ "$all_running" = true ]; then
    print_service_status
    echo -e "\n${GREEN}All services are running!${NC}"
    if [[ "$(uname)" != "Darwin" ]]; then
        echo "The indexer is a one-shot job; it may remain Up while indexing and should finish with Exited (0)."
    fi
    echo -e "You can access the web interface at ${YELLOW}http://localhost:6070${NC}"
    echo "To view logs: docker compose logs -f"
else
    print_service_status
    echo -e "\n${RED}Some services failed to start. Check docker logs for more information:${NC}"
    echo "docker logs zoekt-webserver"
    echo "docker logs caddy"
    exit 1
fi
