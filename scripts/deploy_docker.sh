#!/bin/bash
# deploy_docker.sh - Deploy Sanchaya Zoekt Search on a server using Docker
# This script sets up Docker and deploys the Zoekt server

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Navigate to project root
cd "$PROJECT_ROOT"

# Configuration
WEBSERVER_PORT=6070
INDEXSERVER_PORT=6072

# Install Docker and Docker Compose if not already installed
install_docker() {
    echo "Checking if Docker is installed..."
    if ! command -v docker &>/dev/null; then
        echo "Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl enable docker
        sudo systemctl start docker
        sudo usermod -aG docker $USER
        echo "Docker installed successfully"
        echo "⚠️ NOTE: You may need to log out and log back in for the docker group changes to take effect"
    else
        echo "Docker is already installed: $(docker --version)"
    fi

    echo "Checking if Docker Compose is installed..."
    if ! command -v docker &>/dev/null || ! docker compose version &>/dev/null; then
        echo "Installing Docker Compose plugin..."
        # The compose plugin is typically included with recent Docker Engine installations
        # This is just a fallback for older systems
        sudo mkdir -p /usr/local/lib/docker/cli-plugins
        sudo curl -SL "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose
        sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
        echo "Docker Compose installed successfully"
    else
        echo "Docker Compose is already installed: $(docker compose version)"
    fi
}

# Configure firewall
configure_firewall() {
    echo "Configuring firewall..."
    if command -v ufw &>/dev/null; then
        sudo ufw allow $WEBSERVER_PORT/tcp comment "Zoekt web server"
        echo "UFW firewall rule added for port $WEBSERVER_PORT"
    else
        echo "UFW firewall not found. Please manually configure your firewall to allow port $WEBSERVER_PORT."
    fi
}

# Create data directory with proper permissions
setup_data_dir() {
    echo "Setting up data directory..."
    sudo mkdir -p /var/lib/zoekt
    sudo chown $USER:$USER /var/lib/zoekt
    
    # Link the local data directory to the system location
    mkdir -p "$PROJECT_ROOT/data"
    ln -sf /var/lib/zoekt "$PROJECT_ROOT/data"
}

# Set up the Zoekt services using Docker Compose
deploy_services() {
    echo "Deploying Zoekt services using Docker Compose..."
    
    # Pull the latest images (or build them)
    docker compose pull || docker compose build
    
    # Start the services in detached mode
    docker compose up -d
    
    # Wait for services to start
    echo "Waiting for services to start..."
    sleep 10
    
    # Check if the services are running
    if docker compose ps | grep -q "Up"; then
        echo "✅ Zoekt services are now running"
    else
        echo "❌ There was an issue starting the services"
        docker compose ps
        exit 1
    fi
}

# Set up systemd service to manage Docker Compose
setup_systemd() {
    echo "Setting up systemd service for Zoekt..."
    
    sudo bash -c "cat > /etc/systemd/system/sanchaya-zoekt.service" << EOL
[Unit]
Description=Sanchaya Zoekt Search Service
Requires=docker.service
After=docker.service

[Service]
WorkingDirectory=$PROJECT_ROOT
ExecStart=/usr/local/bin/docker-compose up
ExecStop=/usr/local/bin/docker-compose down
Restart=always
User=$USER

[Install]
WantedBy=multi-user.target
EOL

    sudo systemctl daemon-reload
    sudo systemctl enable sanchaya-zoekt.service
    sudo systemctl start sanchaya-zoekt.service
    
    echo "Systemd service created and started"
}

# Main deployment function
main() {
    echo "===== Deploying Sanchaya Zoekt Search with Docker ====="
    
    install_docker
    configure_firewall
    setup_data_dir
    deploy_services
    setup_systemd
    
    echo "===== Deployment complete! ====="
    echo "Zoekt web interface is available at: http://$(hostname -I | awk '{print $1}'):$WEBSERVER_PORT"
    echo "To check the status of the service: sudo systemctl status sanchaya-zoekt"
    echo "To view logs: docker-compose logs -f"
}

# Run the main function
main
