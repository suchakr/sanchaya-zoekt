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
- Go 1.19 or later
- Git
- Docker (optional, for containerized testing)

### For Deployment (Ubuntu/Debian)
- Linux server (Ubuntu 20.04+ or Debian 11+ recommended)
- Go 1.19 or later
- Git
- At least 4GB RAM (8GB recommended for larger repositories)
- Sufficient disk space for indexed content

## Quick Start

### Local Development

1. Clone this repository:
   ```bash
   git clone https://github.com/suchakr/sanchaya-zoekt.git
   cd sanchaya-zoekt
   ```

2. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```

3. Start the local server:
   ```bash
   ./scripts/run_local.sh
   ```

4. Access the web interface at http://localhost:6070

### Server Deployment

1. Clone this repository on your server:
   ```bash
   git clone https://github.com/suchakr/sanchaya-zoekt.git
   cd sanchaya-zoekt
   ```

2. Run the deployment script:
   ```bash
   ./scripts/deploy.sh
   ```

3. Access the web interface at http://your-server-ip:6070

## Documentation

For more detailed information, see the docs directory:

- [Local Development Guide](docs/development.md)
- [Deployment Guide](docs/deployment.md)
- [Configuration Options](docs/configuration.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Performance Tuning](docs/performance.md)

## License

[MIT License](LICENSE)
