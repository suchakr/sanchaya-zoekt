FROM golang:1.24-bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Zoekt tools (Go 1.17+ syntax)
RUN go install github.com/sourcegraph/zoekt/cmd/zoekt-webserver@main && \
    go install github.com/sourcegraph/zoekt/cmd/zoekt-indexserver@main && \
    go install github.com/sourcegraph/zoekt/cmd/zoekt-git-index@main

# Add Go bin to PATH
ENV PATH="/root/go/bin:${PATH}"

# Create directories for data
RUN mkdir -p /data/index /data/repos

# Set working directory
WORKDIR /app

# Copy config files to container
COPY ./config /app/config

# Add debug code to verify template loading 
RUN echo "<!-- DEBUG: THIS FILE WAS MODIFIED BY DOCKERFILE -->" >> /app/config/templates/index.html.tpl
RUN echo "DEBUG TIMESTAMP: $(date)" >> /app/config/templates/index.html.tpl

# Default command (can be overridden in docker-compose.yml)
CMD ["zoekt-webserver", "-listen", ":6070", "-index", "/data/index"]
