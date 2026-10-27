#!/usr/bin/env bash

# Shared loader for the host-owned Linux production path configuration.
# The env file is intentionally limited to ZOEKT_DATA_DIR; secrets do not belong
# in it, and Compose receives the same file for bind-mount interpolation.
load_zoekt_production_env() {
    local env_file="${ZOEKT_PROD_ENV_FILE:-/etc/sanchaya-zoekt/production.env}"
    local line value=""
    local found=0

    if [[ ! -r "$env_file" ]]; then
        echo "Missing or unreadable Zoekt production env file: $env_file" >&2
        echo "Create it from zoekt.env.prod.example before using Linux production scripts." >&2
        return 2
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "${line//[[:space:]]/}" ]] && continue
        case "$line" in
            \#*) continue ;;
            ZOEKT_DATA_DIR=*)
                if (( found != 0 )); then
                    echo "Duplicate ZOEKT_DATA_DIR in $env_file" >&2
                    return 2
                fi
                value="${line#ZOEKT_DATA_DIR=}"
                found=1
                ;;
            *)
                echo "Unsupported setting in $env_file; only ZOEKT_DATA_DIR is allowed." >&2
                return 2
                ;;
        esac
    done < "$env_file"

    case "$value" in
        /*) ;;
        *)
            echo "ZOEKT_DATA_DIR must be an absolute path in $env_file" >&2
            return 2
            ;;
    esac
    case "$value" in
        *[[:space:]]*|*'#'*|*'$'*)
            echo "ZOEKT_DATA_DIR cannot contain whitespace, #, or interpolation in $env_file" >&2
            return 2
            ;;
    esac

    if (( found != 1 )); then
        echo "ZOEKT_DATA_DIR must be one absolute path without spaces or interpolation in $env_file" >&2
        return 2
    fi

    export ZOEKT_DATA_DIR="$value"
    export ZOEKT_PROD_ENV_FILE="$env_file"
}
