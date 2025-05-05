# Local Development Guide

This guide covers how to set up and use the Sanchaya Zoekt Search project on macOS for local development.

## Prerequisites

Before you begin, ensure you have the following:

- macOS operating system
- Administrative access to install packages
- Terminal access
- Internet connection

## Initial Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/sanchaya-zoekt.git
   cd sanchaya-zoekt
   ```

2. Make the setup script executable:

   ```bash
   chmod +x scripts/setup.sh
   ```

3. Run the setup script:

   ```bash
   ./scripts/setup.sh
   ```

   This script will:
   - Install Go if not already installed (using Homebrew)
   - Install Git if not already installed (using Homebrew)
   - Install Zoekt tools
   - Create necessary data directories
   - Update your PATH to include Go binaries

4. After running the setup script, restart your terminal or run:

   ```bash
   source ~/.zshrc
   ```

## Running the Server Locally

1. Make the run script executable:

   ```bash
   chmod +x scripts/run_local.sh
   ```

2. Run the server:

   ```bash
   ./scripts/run_local.sh
   ```

   This script will:
   - Clone or update the Sanchaya repository
   - Index the repository (this may take a while for the first run)
   - Start the Zoekt index server
   - Start the Zoekt web server

3. Open your browser and navigate to [http://localhost:6070](http://localhost:6070) to access the web interface.

4. To stop the server, press `Ctrl+C` in the terminal where the script is running.

## Development Workflow

### Updating the Index

If you make changes to the Sanchaya repository or want to refresh the index:

1. Stop any running servers with `Ctrl+C`
2. Run `./scripts/run_local.sh` again to update the index and restart the servers

### Customizing the Web Interface

The Zoekt web interface is quite minimal by default. If you want to customize it:

1. Fork the Zoekt repository: [https://github.com/google/zoekt](https://github.com/google/zoekt)
2. Make your changes to the web interface components
3. Build your customized version
4. Install your version instead of the standard one

### Testing

You can test your deployment by:

1. Searching for various terms in different Indic scripts
2. Verifying result highlighting works correctly
3. Testing search performance with different query types
4. Checking that all text files in the repository are properly indexed

## Troubleshooting

### Common Issues

#### Server Fails to Start

```
Error: listen tcp :6070: bind: address already in use
```

- Another process is using port 6070. Stop that process or change the port in the script.

#### Indexing Errors

```
Error during indexing
```

- Check disk space
- Ensure you have read permissions on the repository
- Try removing the index directory and starting fresh

#### Slow Performance

- Increase memory allocation to Go with `export GOMAXPROCS=n` (where n is the number of CPU cores)
- Ensure your machine meets the minimum requirements (4GB RAM recommended)

## Next Steps

Once you've verified everything works locally, you can:

1. Customize the user interface if needed
2. Test with larger repositories
3. Deploy to a server using the `deploy.sh` script
