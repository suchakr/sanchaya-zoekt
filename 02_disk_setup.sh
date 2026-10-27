#!/bin/bash
# 02_disk_setup.sh - Legacy disk setup guard

set -euo pipefail

echo "Stage 2: Checking disk setup..."

if [[ "$(uname)" == "Darwin" ]]; then
    echo "Running on macOS. No separate data-disk setup is needed."
    mkdir -p ./.checkpoints
    if [ -f ./.checkpoints/02_disk_setup.done ]; then
        echo "Stage 2 already completed."
        exit 0
    fi
    touch ./.checkpoints/02_disk_setup.done
    echo "✅ Stage 2: Disk setup not needed on macOS"
    exit 0
fi

echo "Refusing Linux disk setup: this legacy script formats /dev/sdb and mounts it under /mnt." >&2
echo "On the production Azure VM, /mnt is temporary storage and must not hold persistent data." >&2
echo "Do not run this script on Linux. Configure persistent storage explicitly under /srv instead." >&2
exit 2
