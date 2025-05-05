# Deployment Guide

This guide covers deploying the Sanchaya Zoekt Search application on a Linux server (Ubuntu/Debian).

## System Requirements

- Ubuntu 20.04+ or Debian 11+ (other Linux distributions may work but are not officially supported)
- Minimum 4GB RAM (8GB recommended for larger repositories)
- At least 20GB available disk space
- Basic server security measures in place (firewall, SSH hardening, etc.)
- Root or sudo access

## Deployment Steps

### 1. Prepare the Server

Update your system packages:

```bash
sudo apt update
sudo apt upgrade -y
```

Ensure you have git installed:

```bash
sudo apt install -y git
```

### 2. Clone the Repository

Clone the Sanchaya Zoekt repository:

```bash
git clone https://github.com/yourusername/sanchaya-zoekt.git
cd sanchaya-zoekt
```

### 3. Run the Deployment Script

Make the deployment script executable:

```bash
chmod +x scripts/deploy.sh
```

Run the deployment script:

```bash
sudo ./scripts/deploy.sh
```

This script will:
- Create a system user for the Zoekt service
- Install all required dependencies
- Clone the Sanchaya repository
- Set up the Zoekt indexing and web servers
- Configure systemd services for automatic startup
- Set up regular index updates via cron
- Configure firewall rules

### 4. Verify the Installation

After the script completes, verify that the services are running:

```bash
sudo systemctl status zoekt-indexserver
sudo systemctl status zoekt-webserver
```

Access the web interface by navigating to:

```
http://your-server-ip:6070
```

### 5. Configure HTTPS (Optional but Recommended)

For production deployments, it's recommended to set up HTTPS. You can use a reverse proxy like Nginx or Caddy:

#### Example Nginx Configuration:

```bash
sudo apt install -y nginx certbot python3-certbot-nginx

# Create Nginx config
sudo nano /etc/nginx/sites-available/zoekt
```

Add the following configuration:

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://localhost:6070;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Enable the site and get SSL certificate:

```bash
sudo ln -s /etc/nginx/sites-available/zoekt /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
sudo certbot --nginx -d your-domain.com
```

## Managing the Service

### Start/Stop/Restart Services

```bash
# Start services
sudo systemctl start zoekt-indexserver
sudo systemctl start zoekt-webserver

# Stop services
sudo systemctl stop zoekt-indexserver
sudo systemctl stop zoekt-webserver

# Restart services
sudo systemctl restart zoekt-indexserver
sudo systemctl restart zoekt-webserver
```

### View Logs

```bash
# View index server logs
sudo journalctl -u zoekt-indexserver

# View web server logs
sudo journalctl -u zoekt-webserver

# Follow logs in real-time
sudo journalctl -u zoekt-webserver -f
```

### Manual Index Update

To manually update the index:

```bash
sudo /usr/local/bin/update-zoekt-index.sh
```

## Scaling Considerations

### For Larger Repositories

If you're indexing very large repositories or many repositories:

1. Increase the server resources (CPU, RAM)
2. Adjust the Java heap size for improved performance:
   ```bash
   sudo systemctl edit zoekt-indexserver
   ```
   
   Add the following:
   ```
   [Service]
   Environment="GOGC=50"
   ```

3. Consider using SSD storage for better performance

## Backup and Recovery

### Backup

To backup your Zoekt index and repositories:

```bash
sudo tar -czf zoekt-backup.tar.gz /var/lib/zoekt
```

### Recovery

To restore from a backup:

```bash
sudo systemctl stop zoekt-indexserver
sudo systemctl stop zoekt-webserver
sudo rm -rf /var/lib/zoekt/*
sudo tar -xzf zoekt-backup.tar.gz -C /
sudo chown -R zoekt:zoekt /var/lib/zoekt
sudo systemctl start zoekt-indexserver
sudo systemctl start zoekt-webserver
```

## Troubleshooting

### Common Issues

#### Services Fail to Start

Check the logs for detailed error messages:

```bash
sudo journalctl -u zoekt-indexserver -n 50
```

#### High CPU or Memory Usage

If you notice high resource usage:

```bash
# Adjust garbage collection
sudo systemctl edit zoekt-indexserver
```

Add:
```
[Service]
Environment="GOGC=100"
```

#### Web Interface Not Accessible

Check firewall settings:

```bash
sudo ufw status
```

Ensure port 6070 is allowed or that your reverse proxy is configured correctly.
