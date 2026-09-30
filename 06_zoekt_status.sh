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

path_exists() {
    if [[ "$PLATFORM" == "macOS" ]]; then
        test -d "$1"
    else
        sudo test -d "$1"
    fi
}

show_disk_usage() {
    if [[ "$PLATFORM" == "macOS" ]]; then
        df -h "$1"
    else
        sudo df -h "$1"
    fi
}

find_data() {
    if [[ "$PLATFORM" == "macOS" ]]; then
        find "$@"
    else
        sudo find "$@"
    fi
}

show_data_usage() {
    if [[ "$PLATFORM" == "macOS" ]]; then
        du -sh "$@"
    else
        sudo du -sh "$@"
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
if path_exists "$data_dir"; then
    show_disk_usage "$data_dir"

    index_dir="$data_dir/index"
    repos_dir="$data_dir/repos"
    if path_exists "$index_dir"; then
        index_shards="$(find_data "$index_dir" -maxdepth 1 -type f -name '*.zoekt' -print | wc -l | tr -d ' ')"
        index_tmp="$(find_data "$index_dir" -maxdepth 1 -type f -name '*.tmp' -print | wc -l | tr -d ' ')"
        echo "Index shards: $index_shards"
        echo "Index temporary files: $index_tmp"
        show_data_usage "$index_dir"
    else
        echo "missing index directory: $index_dir"
    fi
    if path_exists "$repos_dir"; then
        show_data_usage "$repos_dir"
    else
        echo "missing repository directory: $repos_dir"
    fi
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
