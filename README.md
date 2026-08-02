# Sanchaya Zoekt Search

A self-hosted search application that provides full-text search capabilities for Indic language content from the Sanchaya GitHub repository.

## Overview

This project implements a Zoekt search server specifically configured for Unicode/Indic script support. It indexes text files containing Devanagari and other Indic scripts from the Sanchaya repository and provides a public web interface for searching without authentication requirements.

## Features

- **Full Unicode Support**: Properly handles Devanagari and other Indic scripts
- **Fast Search**: Leverages Zoekt's efficient indexing for quick search results
- **No Authentication Required**: Public web interface for easy access
- **Fuzzy Search**: Find results even with slight misspellings or variations
- **Result Highlighting**: Clear indication of matched terms in results

## Project Structure

```
sanchaya-zoekt/
├── config/                  # Configuration files and templates
│   ├── Caddyfile           # Caddy web server configuration
│   └── templates/          # HTML templates for the search interface
├── 01_docker_install.sh    # Docker installation check
├── 02_disk_setup.sh        # Disk preparation
├── 03_zoekt_prep.sh        # Zoekt preparation
├── 04_zoekt_start.sh       # Start services
├── 05_zoekt_stop.sh        # Stop services
├── 06_zoekt_status.sh      # Show service and deployment status
├── docker-compose.yml              # Main Docker Compose configuration
├── docker-compose.override.yml     # linux-specific configuration
├── docker-compose.mac.yml          # macOS-specific configuration
└── docker-compose.prod.yml         # production HTTP/HTTPS port bindings
```

## Requirements

### For Development (macOS)

- **Docker Desktop**
- Git

### For Deployment (Ubuntu/Debian)

- Linux server (Ubuntu 20.04+ or Debian 11+ recommended)
- **Docker and Docker Compose**
- Git
- At least 4GB RAM (8GB recommended for larger repositories)
- Sufficient disk space for indexed content

## Architecture

This application consists of three main components:

1. **zoekt-webserver**: Serves the web interface and handles search queries.
2. **indexer**: One-shot job that clones or updates the Sanchaya repository and indexes all text files.
3. **caddy**: Reverse proxy that provides access to the search interface.

## Quick Start

### Setup

1. Clone this repository:

   ```bash
   git clone https://github.com/suchakr/sanchaya-zoekt.git
   cd sanchaya-zoekt
   ```

2. Do the one-time setup:

   ```bash
   chmod +x *.sh
   ./01_docker_install.sh
   ./02_disk_setup.sh
   ./03_zoekt_prep.sh
   ```

   This will:

   - **01_docker_install.sh**: Checks if Docker is installed and running. If not, it will guide you through the installation process.
   - **02_disk_setup.sh**: Prepares the disk for Docker containers. This is NOP for macOS.
   - **03_zoekt_prep.sh**: Prepares the Zoekt indexer and web server creating the necessary directories for data storage.

3. Start the services:

   ```bash
   ./04_zoekt_start.sh --build
   ```

   This will:

   - Check if you're running on macOS/Linux and use the appropriate configuration
   - Start the Docker containers (caddy, zoekt-webserver, indexer)
   - Verify that the services are running properly

4. Access the search interface at: `http://localhost:6070`

   Local development exposes only port `6070` and uses `config/Caddyfile`.
   Public HTTP/HTTPS ports `80` and `443` plus the `sanchaya.rasowshi.us`
   virtual host are added only for Linux production deployment, where the
   scripts select `config/Caddyfile.prod`.

5. To stop the services:

   ```bash
   ./05_zoekt_stop.sh
   ```

For routine operation, use `04_zoekt_start.sh` to start, `05_zoekt_stop.sh`
to stop, and `06_zoekt_status.sh` to inspect Git, containers, storage, and the
HTTP endpoint. Use `./04_zoekt_start.sh --build` for the first start or after
Dockerfile/dependency changes. The same commands work on macOS and on the
Linux production VM; the scripts select the appropriate Compose overlays.

For the Azure production release procedure, including the SSH, Git, Compose,
indexing, verification, and rollback steps, see [DEPLOYMENT.md](DEPLOYMENT.md).

## CLI Search (without browser)

Install the `zoekt` CLI once using Go:

```bash
go install github.com/sourcegraph/zoekt/cmd/zoekt@main
```

Add Go binaries to your PATH in `~/.bashrc`:

```bash
export PATH="$HOME/go/bin:$PATH"
source ~/.bashrc
```

**Optional — set this project's index as default** so `zoekt` works from any directory:

```bash
ln -s /path/to/sanchaya-zoekt/data/index ~/.zoekt
```

**Search:**

```bash
# Basic search (uses ~/.zoekt if symlinked, else specify -index_dir)
zoekt "search term"

# Explicit index path (no symlink needed)
zoekt -index_dir /path/to/sanchaya-zoekt/data/index "search term"

# Case-insensitive
zoekt -i "search term"

# Restrict to a specific repo
zoekt -repo sanchaya "search term"

# Show file paths only (no snippet)
zoekt -l "search term"
```

CLI output lists matching files, line numbers, and surrounding context. Useful for scripting or quick lookups without starting Docker.

## Data Storage

By default, the application stores data in the following locations:

- **macOS**: Local `./data` directory within the project folder
- **Linux**: `/mnt/docker-data/sanchaya-zoekt-data` directory

You can change the Linux data directory by setting the `ZOEKT_DATA_DIR` environment variable:

Note these are mount points for the Docker containers. You can change the mount points in the `docker-compose.yml` file if needed.

```bash
export ZOEKT_DATA_DIR=/path/to/your/data/directory
./02_disk_setup.sh
./03_zoekt_prep.sh
```

### Caddy Configuration

The local Caddy web server is configured to serve the search interface at `http://localhost:6070` using `config/Caddyfile`.

The local Caddyfile reverse proxies requests to the `zoekt-webserver` service, which serves the search interface at port 6070. This is meant to verify locally that the web server is working.
```
:6070 {
    reverse_proxy zoekt-webserver:6070
```

The production Caddyfile is `config/Caddyfile.prod`. It keeps the local `:6070` listener and adds HTTPS requests for the `sanchaya.rasowshi.us` domain. It also redirects HTTP requests to HTTPS. The `header_up` directive sets the `Host` header to the original request's host, which is important for proper routing.
```
sanchaya.rasowshi.us {
    tls {
        protocols tls1.2 tls1.3
    }

    reverse_proxy zoekt-webserver:6070 {
        header_up Host {http.request.host}
    }
}
```

Sourcegraph is intentionally not part of the default Caddy configuration. If you still need to proxy an independently managed Sourcegraph deployment, use `config/Caddyfile.sourcegraph.example` as a starting point in a separate Caddy deployment or copy it into `config/Caddyfile` only for that host. This keeps the Zoekt deployment independent of the defunct Sourcegraph experiment.

If you know what you're doing, you can modify the Caddyfile to suit your needs. For example, you can change the domain names, add more reverse proxy rules, or enable additional Caddy features.

After making changes to the Caddyfile, restart the services.

### Indexing Configuration

The indexing parameters can be customized by modifying the `indexer` service in the `docker-compose.yml` file. You can adjust:

- Maximum file size (`-file_limit`)
- Sharding parameters (`-shard_limit`)
- Parallelism (`-parallelism`)
- Large file handling (`-large_file`)

## Troubleshooting

### Check Container Status

```bash
docker ps --filter "name=zoekt|caddy"
```

### View Container Logs

```bash
# View logs for all containers
docker compose logs

# View logs for a specific container
docker logs zoekt-webserver
docker logs caddy
docker logs indexer
```

### Common Issues

1. **Permission Issues**: Ensure the data directory has the correct permissions (777 for development, 755 for production).
2. **Port Conflicts**: If the 6070 port is already in use, change the port in the Caddyfile and docker-compose.yml.
3. **Indexing Failures**: If indexing fails, check the indexer logs and increase memory allocation if needed.

## License

[MIT License](LICENSE)
