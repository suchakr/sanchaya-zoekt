# Production Deployment Runbook

This runbook deploys the `feat/google-analytics` branch to the Azure VM serving
`https://sanchaya.rasowshi.us`.

Services:

- `zoekt-caddy`: public HTTP/HTTPS entry point and static Labs files.
- `zoekt-webserver`: the long-running search application.
- `indexer`: a one-shot job that updates the Sanchaya checkout and builds the Zoekt index.

Production index and repository data live at
`/mnt/docker-data/sanchaya-zoekt-data`. Do not use `docker compose down -v`.

The current Azure VM uses a 16 GB `/mnt` data disk. This is below the
recommended production headroom for Docker layers, the repository, and Zoekt
shards; monitor it with `06_zoekt_status.sh` and plan a disk expansion.

## Canonical operating protocol

Use the numbered scripts for normal operation. They hide the difference between
local macOS storage and the production Linux Compose overlays.

Local development:

```bash
./04_zoekt_start.sh --build  # first start or Dockerfile/dependency changes
# develop and test
./06_zoekt_status.sh
./05_zoekt_stop.sh
```

Remote release:

```bash
git push origin feat/google-analytics
ssh sanchaya.rasowshi.us
cd ~/sg/sanchaya-zoekt
git pull --ff-only origin feat/google-analytics
./04_zoekt_start.sh
./06_zoekt_status.sh
```

Use `./04_zoekt_start.sh --build` on the VM when the pulled change modifies
the Dockerfile or image dependencies.

Do not stop the remote service before an ordinary release. `04_zoekt_start.sh`
reconciles the running services with the pulled checkout. Use `05_zoekt_stop.sh`
only for intentional shutdown or maintenance. `06_zoekt_status.sh` is read-only.

## Normal release

### 1. Push from the development machine

```bash
cd /Users/sunder/projects/sanchaya-zoekt
git status --short --branch
git diff --check
git push origin feat/google-analytics
git log -1 --oneline
```

Do not continue until the push succeeds.

### 2. Connect to the VM

The SSH entry for this machine maps the host to user `kumars` and
`~/.ssh/id_ed25519`:

```bash
ssh sanchaya.rasowshi.us
```

Equivalent explicit form:

```bash
ssh -i ~/.ssh/id_ed25519 kumars@sanchaya.rasowshi.us
```

### 3. Update the VM checkout

```bash
cd ~/sg/sanchaya-zoekt
git status --short --branch
git branch --show-current
git pull --ff-only origin feat/google-analytics
git log -1 --oneline
grep '^FROM ' Dockerfile
```

The current Docker base image is `golang:1.25.12-bookworm`. If the `FROM` line
shows an unavailable tag, stop before building. The failed deployment used
`golang:1.25.9-bullseye`, which does not exist.

### 4. Validate and deploy

Run from the repository root. The persistent-data override is required in
production; the production overlay publishes ports `80` and `443`.

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  config --quiet
```

The numbered script is the normal deployment entry point:

```bash
./04_zoekt_start.sh
```

It validates the Compose configuration and runs the equivalent of:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  up -d
```

Pass `--build` to the script when the Dockerfile or image dependencies changed.
Do not add `-v`; Caddy's named state and the host index data must survive.

### 5. Wait for indexing and inspect state

When `04_zoekt_start.sh` starts the indexer as a Compose service, it may show
`Up` while working. A successful completion is `Exited (0)`.

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  ps -a
```

To follow the indexer:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  logs --tail=100 -f indexer
```

Press `Ctrl-C` only stops log following; it does not stop the container.

The same information is summarized by:

```bash
./06_zoekt_status.sh
```

For the full `04_zoekt_start.sh` path, expected steady state is:

```text
zoekt-caddy       Up
zoekt-webserver   Up
indexer           Exited (0)
```

For the explicit `run --rm --no-deps indexer` path below, the successful
indexer container is deliberately removed. In that case, use the command's
successful return and `06_zoekt_status.sh`'s shard and temporary-file counts as
the index verification; no indexer container in `ps -a` is expected.

### 6. Smoke test

```bash
curl -sS -o /dev/null -w 'HTTP  %{http_code}  %{url_effective}\n' \
  http://sanchaya.rasowshi.us/
curl -sS -o /dev/null -w 'HTTPS %{http_code}  %{url_effective}\n' \
  https://sanchaya.rasowshi.us/
curl -sS -o /dev/null -w 'SEARCH %{http_code}  %{url_effective}\n' \
  'https://sanchaya.rasowshi.us/search?q=%E0%A4%A4%E0%A4%BF%E0%A4%AE%E0%A4%BF%E0%A4%B0%E0%A4%BE'
```

HTTP should redirect to HTTPS. The HTTPS and search requests should return
`200`. In a browser also check home, normal search, the one-character guard,
advanced search, IAST, history, Labs, and `/labs/`.

## App release versus corpus refresh

For HTML, CSS, Caddy, or application-code changes, the indexer need not run.
Use the same Compose files and target only the long-running services:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  up -d --force-recreate zoekt-webserver caddy
```

This refreshes the long-running services without rebuilding the Docker image or
starting a corpus index. Use `./04_zoekt_start.sh --build` when the Dockerfile
or image dependencies changed.

When the upstream Sanchaya repository changed, run the indexer and then
restart the webserver:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  run --rm --no-deps indexer
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  restart zoekt-webserver
```

The indexer clones or fast-forwards `https://github.com/cahcblr/sanchaya.git`
and indexes its `main` branch. A successful run should leave a consistent
current `sanchaya_v16.*.zoekt` shard set, no `.tmp` files, and enough free
space for the next refresh.

## One-time setup on a new VM

The existing Azure VM is already prepared. For a new VM:

```bash
git clone https://github.com/suchakr/sanchaya-zoekt.git ~/sg/sanchaya-zoekt
cd ~/sg/sanchaya-zoekt
git switch feat/google-analytics
chmod +x *.sh
./01_docker_install.sh
lsblk
df -h
```

`02_disk_setup.sh` assumes `/dev/sdb` is the intended empty disk and can
format it. Never run it blindly on an existing server. After confirming the
disk, run:

```bash
./02_disk_setup.sh
./03_zoekt_prep.sh
./04_zoekt_start.sh
```

## Troubleshooting

- Build says a Go image is not found: pull the branch and inspect `FROM`.
- Status says Docker is inaccessible: start Docker Desktop locally, or use the
  configured `sudo docker` access on the VM.
- Webserver has an old creation time: rerun `up -d --build --force-recreate zoekt-webserver`.
- Indexer exits nonzero: inspect `logs --tail=200 indexer`, disk space, and permissions.
- Caddy returns `502`: inspect `docker logs zoekt-caddy` and `docker logs zoekt-webserver`.
- TLS fails: confirm DNS and Azure/VM firewall access to TCP `80` and `443`.

### Disk-full index failure

If the indexer reports `no space left on device`:

1. Confirm the indexer is stopped.
2. Inspect `sudo docker system df -v` and `sudo df -h /mnt`.
3. Remove only dangling images with `sudo docker image prune` after reviewing the list.
4. Remove failed index temporary files only after the indexer is stopped:

   ```bash
   sudo find /mnt/docker-data/sanchaya-zoekt-data/index \
     -maxdepth 1 -type f -name '*.tmp' -print -delete
   ```

5. Rerun the explicit indexer command and require a successful return.

Do not use `docker system prune -a`, `docker volume prune`, or delete the
entire index directory without reviewing what is being removed. If the index
directory contains two shard naming groups, inspect them before cleanup; stop
the webserver before removing an obsolete group. The current VM's 16 GB disk
should ultimately be expanded rather than managed at this margin.

Stop without deleting data:

```bash
./05_zoekt_stop.sh
```

## Emergency rollback

Use a known-good commit without rewriting the remote branch:

```bash
cd ~/sg/sanchaya-zoekt
git switch --detach <known-good-commit>
./04_zoekt_start.sh
```

Afterward return the VM to the deployment branch:

```bash
git switch feat/google-analytics
git pull --ff-only origin feat/google-analytics
```

The production Caddy configuration is intentionally independent of the old
Sourcegraph experiment.
