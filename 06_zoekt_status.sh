#!/bin/bash
# 06_zoekt_status.sh - Show Git, container, storage, and endpoint status

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ "$(uname)" == "Darwin" ]]; then
    PLATFORM="macOS"
    compose_files=(
        -f docker-compose.yml
        -f docker-compose.mac.yml
    )
    data_dir="./data"
    endpoint="http://localhost:6070/"
else
    PLATFORM="Linux production"
    compose_files=(
        -f docker-compose.yml
        -f docker-compose.override.yml
        -f docker-compose.prod.yml
    )
    data_dir="${ZOEKT_DATA_DIR:-/mnt/docker-data/sanchaya-zoekt-data}"
    endpoint="https://sanchaya.rasowshi.us/"
fi

compose() {
    if [[ "$PLATFORM" == "macOS" ]]; then
        docker compose "${compose_files[@]}" "$@"
    else
        sudo env CADDYFILE=./config/Caddyfile.prod \
            docker compose "${compose_files[@]}" "$@"
    fi
}

echo "Platform: $PLATFORM"
echo
echo "Git:"
git status --short --branch
printf "Commit: "
git log -1 --oneline

echo
echo "Compose configuration:"
compose config --quiet
echo "valid"

echo
echo "Containers:"
if ! compose ps -a; then
    echo "Unable to query containers; the Docker daemon may be stopped or inaccessible."
fi

echo
echo "Data storage:"
if [[ -d "$data_dir" ]]; then
    df -h "$data_dir"
else
    echo "missing: $data_dir"
fi

echo
echo "Endpoint: $endpoint"
if command -v curl >/dev/null 2>&1; then
    http_status="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 10 "$endpoint" || true)"
    if [[ -z "$http_status" || "$http_status" == "000" ]]; then
        http_status="unreachable"
    fi
    echo "HTTP status: $http_status"
else
    echo "curl is not installed; endpoint not checked"
fi
