#!/bin/bash
# run_local.sh - Start the Zoekt server locally for development

set -e  # Exit on error

# Default to Docker mode unless specified otherwise
MODE=${1:-docker}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Navigate to project root
cd "$PROJECT_ROOT"

# Configuration
INDEX_DIR="$PROJECT_ROOT/data/index"
REPOS_DIR="$PROJECT_ROOT/data/repos"
CONFIG_FILE="$PROJECT_ROOT/config/zoekt.json"
SANCHAYA_REPO_URL="https://github.com/cahcblr/sanchaya" # Repository to be indexed
WEBSERVER_PORT=6070
INDEXSERVER_PORT=6072

# Create directories if they don't exist
mkdir -p "$INDEX_DIR"
mkdir -p "$REPOS_DIR"

if [[ "$MODE" == "docker" ]]; then
    echo "Starting Zoekt using Docker..."
    
    # Check if Docker is running
    if ! docker info > /dev/null 2>&1; then
        echo "Docker is not running. Please start Docker Desktop and try again."
        exit 1
    fi
    
    # Start services using docker compose
    echo "Starting Zoekt services with docker compose..."
    docker compose up -d
    
    # Wait a moment for services to initialize
    echo "Waiting for services to initialize..."
    sleep 5
    
    # Check if containers are running
    if docker compose ps | grep -q "Up"; then
        echo "✅ Zoekt services are running"
        echo "✅ Web interface is available at: http://localhost:$WEBSERVER_PORT"
        echo "To view logs: docker compose logs -f"
    else
        echo "❌ There was an issue starting the services"
        docker compose ps
        exit 1
    fi
    
elif [[ "$MODE" == "direct" ]]; then
    echo "Starting Zoekt using direct installation..."
    
    # Function to check if a process is running on a specific port
    is_port_in_use() {
        lsof -i:"$1" > /dev/null 2>&1
    }

    # Clone/update the Sanchaya repository
    echo "Fetching Sanchaya repository..."
    if [ -d "$REPOS_DIR/sanchaya" ]; then
        echo "Updating existing Sanchaya repository..."
        (cd "$REPOS_DIR/sanchaya" && git pull)
    else
        echo "Cloning Sanchaya repository..."
        git clone "$SANCHAYA_REPO_URL" "$REPOS_DIR/sanchaya"
    fi

    # Create temporary configuration for zoekt-git-index
    echo "Creating configuration file..."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    cat > "$CONFIG_FILE" <<EOL
{
    "RepoName": "sanchaya",
    "IndexOptions": {
        "LargeFiles": true,
        "DetectLanguages": true,
        "SymbolsEnabled": true,
        "Ctags": "",
        "IgnoreNonIndexable": false
    }
}
EOL

    # Index the repository
    echo "Indexing the repository (this may take a while)..."
    zoekt-git-index -index="$INDEX_DIR" -repo_cache="$REPOS_DIR" \
        -require_ctags=false -incremental -branch main "$REPOS_DIR/sanchaya"

    # Start the index server in the background if not already running
    if is_port_in_use "$INDEXSERVER_PORT"; then
        echo "Index server is already running on port $INDEXSERVER_PORT"
    else
        echo "Starting zoekt-indexserver on port $INDEXSERVER_PORT..."
        zoekt-indexserver -listen ":$INDEXSERVER_PORT" -index "$INDEX_DIR" &
        INDEXSERVER_PID=$!
        echo "Zoekt index server started with PID: $INDEXSERVER_PID"
        # Save PID to file for later cleanup
        echo $INDEXSERVER_PID > "$PROJECT_ROOT/indexserver.pid"
    fi

    # Start the web server in the foreground
    echo "Starting zoekt-webserver on port $WEBSERVER_PORT..."
    echo "Web interface will be available at http://localhost:$WEBSERVER_PORT"
    echo "Press Ctrl+C to stop the server"

    zoekt-webserver -listen ":$WEBSERVER_PORT" -index "$INDEX_DIR" -rpc_index ":$INDEXSERVER_PORT"

    # This code will run when the script is terminated with Ctrl+C
    cleanup() {
        echo "Shutting down servers..."
        if [ -f "$PROJECT_ROOT/indexserver.pid" ]; then
            SAVED_PID=$(cat "$PROJECT_ROOT/indexserver.pid")
            if kill -0 $SAVED_PID 2>/dev/null; then
                kill $SAVED_PID
                echo "Index server (PID: $SAVED_PID) stopped"
            fi
            rm "$PROJECT_ROOT/indexserver.pid"
        fi
        echo "Cleanup complete"
    }

    trap cleanup EXIT
else
    echo "Invalid mode: $MODE"
    echo "Usage: ./scripts/run_local.sh [docker|direct]"
    echo "  docker  - Run using Docker (default)"
    echo "  direct  - Run using direct installation"
    exit 1
fi
