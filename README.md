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
├── config/         # Configuration files
├── docs/           # Documentation
├── scripts/        # Installation and deployment scripts
└── src/            # Source code
```

## Requirements

### For Development (macOS)

- **Docker Desktop** (recommended default approach)
- Git

For direct installation (alternative approach):

- Go 1.19 or later
- Git

### For Deployment (Ubuntu/Debian)

- Linux server (Ubuntu 20.04+ or Debian 11+ recommended)
- **Docker and Docker Compose** (recommended default approach)
- Git
- At least 4GB RAM (8GB recommended for larger repositories)
- Sufficient disk space for indexed content

For direct installation (alternative approach):

- Go 1.19 or later
- Git

## Quick Start

### Local Development

1. Clone this repository:

   ```bash
   git clone https://github.com/suchakr/sanchaya-zoekt.git
   cd sanchaya-zoekt
   ```

2. Run the setup script:

   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

   This will set up Docker by default. For direct installation without Docker, use:

   ```bash
   ./scripts/setup.sh direct
   ```

3. Start the local server:

   ```bash
   chmod +x scripts/run_local.sh
   ./scripts/run_local.sh
   ```

   This will use Docker by default. For direct installation, use:

   ```bash
   ./scripts/run_local.sh direct
   ```

4. Access the web interface at [http://localhost:6070](http://localhost:6070)

### Server Deployment

1. Clone this repository on your server:

   ```bash
   git clone https://github.com/suchakr/sanchaya-zoekt.git
   cd sanchaya-zoekt
   ```

2. For Docker-based deployment (recommended):

   ```bash
   chmod +x scripts/deploy_docker.sh
   ./scripts/deploy_docker.sh
   ```

3. For traditional deployment without Docker:

   ```bash
   chmod +x scripts/deploy.sh
   ./scripts/deploy.sh
   ```

4. Access the web interface at [http://your-server-ip:6070](http://your-server-ip:6070)

## Docker Deployment Benefits

Using Docker (the default approach) provides several advantages:

- **Easy Setup**: One-command installation with all dependencies handled automatically
- **Consistent Environment**: Same configuration in development and production
- **Isolated Services**: Containerized applications don't interfere with host system
- **Simple Updates**: Easy to update to newer versions of Zoekt
- **Resource Management**: Docker handles resource allocation for optimal performance

## Documentation

For more detailed information, see the docs directory:

- [Local Development Guide](docs/development.md)
- [Deployment Guide](docs/deployment.md)
- [Configuration Options](docs/configuration.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Performance Tuning](docs/performance.md)

## License

[MIT License](LICENSE)
