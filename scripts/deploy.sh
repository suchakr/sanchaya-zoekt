#!/bin/bash
# deploy.sh - Deploy Sanchaya Zoekt Search on a server (Ubuntu/Debian)
# This script sets up the environment and starts the Zoekt server

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Navigate to project root
cd "$PROJECT_ROOT"

# Configuration
INDEX_DIR="/var/lib/zoekt/index"
REPOS_DIR="/var/lib/zoekt/repos"
CONFIG_DIR="/etc/zoekt"
LOG_DIR="/var/log/zoekt"
SYSTEMD_DIR="/etc/systemd/system"
SANCHAYA_REPO_URL="https://github.com/cahcblr/sanchaya" # Repository to be indexed
WEBSERVER_PORT=6070
INDEXSERVER_PORT=6072

# Create a zoekt user and necessary directories
create_user_and_dirs() {
    echo "Creating zoekt user and directories..."
    if ! id -u zoekt >/dev/null 2>&1; then
        sudo useradd --system --home-dir /var/lib/zoekt --shell /bin/false zoekt
    fi
    
    sudo mkdir -p "$INDEX_DIR" "$REPOS_DIR" "$CONFIG_DIR" "$LOG_DIR"
    sudo chown -R zoekt:zoekt "$INDEX_DIR" "$REPOS_DIR" "$CONFIG_DIR" "$LOG_DIR"
}

# Install dependencies
install_dependencies() {
    echo "Updating package lists..."
    sudo apt-get update
    
    echo "Installing dependencies..."
    sudo apt-get install -y git golang-go ctags
    
    # Install Zoekt tools
    echo "Installing Zoekt..."
    GOPATH=$(go env GOPATH)
    go install github.com/google/zoekt/cmd/zoekt-indexserver@latest
    go install github.com/google/zoekt/cmd/zoekt-webserver@latest
    go install github.com/google/zoekt/cmd/zoekt-git-index@latest
    
    # Copy binaries to a system-wide location
    sudo cp "$GOPATH/bin/zoekt-"* /usr/local/bin/
}

# Clone the Sanchaya repository
clone_repository() {
    echo "Cloning Sanchaya repository..."
    sudo -u zoekt git clone "$SANCHAYA_REPO_URL" "$REPOS_DIR/sanchaya"
}

# Create configuration files
create_config_files() {
    echo "Creating configuration files..."
    
    # Zoekt configuration
    sudo bash -c "cat > $CONFIG_DIR/zoekt.json" <<EOL
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
    sudo chown zoekt:zoekt "$CONFIG_DIR/zoekt.json"
    
    # Systemd service for zoekt-indexserver
    sudo bash -c "cat > $SYSTEMD_DIR/zoekt-indexserver.service" <<EOL
[Unit]
Description=Zoekt Index Server
After=network.target

[Service]
Type=simple
User=zoekt
ExecStart=/usr/local/bin/zoekt-indexserver -listen :${INDEXSERVER_PORT} -index ${INDEX_DIR}
Restart=on-failure
StandardOutput=append:${LOG_DIR}/indexserver.log
StandardError=append:${LOG_DIR}/indexserver.error.log

[Install]
WantedBy=multi-user.target
EOL

    # Systemd service for zoekt-webserver
    sudo bash -c "cat > $SYSTEMD_DIR/zoekt-webserver.service" <<EOL
[Unit]
Description=Zoekt Web Server
After=network.target zoekt-indexserver.service

[Service]
Type=simple
User=zoekt
ExecStart=/usr/local/bin/zoekt-webserver -listen :${WEBSERVER_PORT} -index ${INDEX_DIR} -rpc_index :${INDEXSERVER_PORT}
Restart=on-failure
StandardOutput=append:${LOG_DIR}/webserver.log
StandardError=append:${LOG_DIR}/webserver.error.log

[Install]
WantedBy=multi-user.target
EOL

    # Index update cron job script
    sudo bash -c "cat > /usr/local/bin/update-zoekt-index.sh" <<EOL
#!/bin/bash
cd ${REPOS_DIR}/sanchaya && git pull
/usr/local/bin/zoekt-git-index -index=${INDEX_DIR} -repo_cache=${REPOS_DIR} -require_ctags=false -incremental -branch main ${REPOS_DIR}/sanchaya
EOL
    sudo chmod +x /usr/local/bin/update-zoekt-index.sh
    
    # Add cron job to update index every 6 hours
    (sudo crontab -l 2>/dev/null; echo "0 */6 * * * /usr/local/bin/update-zoekt-index.sh") | sudo crontab -
}

# Index the repository and start services
index_and_start() {
    echo "Performing initial indexing (this may take a while)..."
    sudo -u zoekt /usr/local/bin/zoekt-git-index -index="$INDEX_DIR" -repo_cache="$REPOS_DIR" \
        -require_ctags=false -branch main "$REPOS_DIR/sanchaya"
    
    echo "Enabling and starting services..."
    sudo systemctl daemon-reload
    sudo systemctl enable zoekt-indexserver.service
    sudo systemctl enable zoekt-webserver.service
    sudo systemctl start zoekt-indexserver.service
    sudo systemctl start zoekt-webserver.service
    
    echo "Checking service status..."
    sudo systemctl status zoekt-indexserver.service --no-pager
    sudo systemctl status zoekt-webserver.service --no-pager
}

# Configure firewall
configure_firewall() {
    echo "Configuring firewall..."
    if command -v ufw >/dev/null 2>&1; then
        sudo ufw allow "$WEBSERVER_PORT/tcp" comment "Zoekt web server"
        echo "UFW firewall rule added for port $WEBSERVER_PORT"
    else
        echo "UFW firewall not found. Please manually configure your firewall to allow port $WEBSERVER_PORT."
    fi
}

# Run all installation steps
main() {
    echo "===== Installing Sanchaya Zoekt Search ====="
    create_user_and_dirs
    install_dependencies
    clone_repository
    create_config_files
    index_and_start
    configure_firewall
    
    echo "===== Installation complete! ====="
    echo "Zoekt web interface is available at: http://$(hostname -I | awk '{print $1}'):$WEBSERVER_PORT"
    echo "Log files are located in: $LOG_DIR"
}

# Run the main function
main
