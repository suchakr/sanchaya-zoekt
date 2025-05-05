# Configuration Guide

This document outlines the configuration options for Sanchaya Zoekt Search.

## Configuration Files

### zoekt.json

The main configuration file for Zoekt is located at:
- Local development: `./config/zoekt.json`
- Server deployment: `/etc/zoekt/zoekt.json`

This file controls indexing behavior and options:

```json
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
```

### Configuration Options

#### RepoName
The display name for the repository.

#### IndexOptions

- **LargeFiles**: `true` to index large files, `false` to skip files over a certain size
- **DetectLanguages**: `true` to enable language detection for syntax highlighting
- **SymbolsEnabled**: `true` to index symbols for improved search capabilities
- **Ctags**: Path to ctags binary if custom location is needed
- **IgnoreNonIndexable**: `false` to attempt indexing all files, `true` to skip files detected as non-indexable

## Server Configuration

### Ports

- **Web Server**: Default port is 6070 (HTTP interface)
- **Index Server**: Default port is 6072 (RPC for index management)

To change these ports:

1. For local development, edit the `run_local.sh` script:
   ```bash
   WEBSERVER_PORT=8080  # Change to desired port
   INDEXSERVER_PORT=8082  # Change to desired port
   ```

2. For server deployment, edit the systemd service files:
   ```bash
   sudo systemctl edit zoekt-webserver
   ```
   
   Add:
   ```
   [Service]
   ExecStart=
   ExecStart=/usr/local/bin/zoekt-webserver -listen :8080 -index /var/lib/zoekt/index -rpc_index :8082
   ```

   Then edit the index server:
   ```bash
   sudo systemctl edit zoekt-indexserver
   ```
   
   Add:
   ```
   [Service]
   ExecStart=
   ExecStart=/usr/local/bin/zoekt-indexserver -listen :8082 -index /var/lib/zoekt/index
   ```

## Customizing for Indic Scripts

Zoekt's default configuration works well with Unicode, including Devanagari and other Indic scripts. However, to optimize for Indic languages:

### Character Set Configuration

For better handling of Indic scripts, you can customize character sets by modifying the search tokenization. This requires modifying Zoekt source code and rebuilding.

### Unicode Normalization

For consistent search results with Indic scripts that may have multiple Unicode representations:

1. Create a file `/etc/zoekt/unicode.json`:
   ```json
   {
     "NormalizeUnicode": true
   }
   ```

2. Update your zoekt-webserver service to use this file:
   ```bash
   sudo systemctl edit zoekt-webserver
   ```
   
   Add:
   ```
   [Service]
   ExecStart=
   ExecStart=/usr/local/bin/zoekt-webserver -unicode_config=/etc/zoekt/unicode.json -listen :6070 -index /var/lib/zoekt/index -rpc_index :6072
   ```

## Performance Tuning

### Memory Usage

Adjust garbage collection to balance memory usage and performance:

```bash
sudo systemctl edit zoekt-indexserver
```

Add:
```
[Service]
Environment="GOGC=50"
```

Lower values reduce memory usage but increase CPU usage. Higher values do the opposite.

### Index Sharding

For very large repositories, enable index sharding:

```bash
sudo systemctl edit zoekt-indexserver
```

Add:
```
[Service]
ExecStart=
ExecStart=/usr/local/bin/zoekt-indexserver -listen :6072 -index /var/lib/zoekt/index -shard_limit=100M
```

This splits the index into 100MB shards, which can improve memory management.

## Custom Web Interface

### CSS Customization

To customize the appearance of the web interface, create a custom CSS file and mount it:

1. Create a file `/etc/zoekt/custom.css` with your styling
2. Update the zoekt-webserver service:
   ```bash
   sudo systemctl edit zoekt-webserver
   ```
   
   Add:
   ```
   [Service]
   ExecStart=
   ExecStart=/usr/local/bin/zoekt-webserver -custom_css=/etc/zoekt/custom.css -listen :6070 -index /var/lib/zoekt/index -rpc_index :6072
   ```

### Template Customization

For more extensive UI customization, you'll need to fork and modify the Zoekt source code.

## Security Configuration

### IP Restrictions

To restrict access to specific IP addresses:

```bash
sudo apt install -y iptables-persistent
sudo iptables -A INPUT -p tcp --dport 6070 -s 192.168.1.0/24 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 6070 -j DROP
sudo netfilter-persistent save
```

### Reverse Proxy Authentication

You can add basic authentication by setting up a reverse proxy like Nginx:

```nginx
server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        auth_basic "Restricted Access";
        auth_basic_user_file /etc/nginx/.htpasswd;
        proxy_pass http://localhost:6070;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Create a password file:
```bash
sudo apt install -y apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd username
```
