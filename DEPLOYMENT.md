# Production deployment runbook

This runbook operates the Azure VM serving `https://sanchaya.rasowshi.us`.
The normal production checkout is `~/sg/sanchaya-zoekt`.

## Production contract

- `zoekt-caddy` is the only public entry point on ports 80 and 443.
- `zoekt-webserver` serves the UI and private RPC on the Docker network.
- `indexer` is a one-shot corpus refresh and shard build.
- Persistent repositories and shards live under
  `/mnt/docker-data/sanchaya-zoekt-data`.
- The Patra Darpan retrieval project joins `sanchaya-zoekt_default`; this
  repository does not build or own Qdrant, retrieval releases, or MCP code.
- Never use `docker compose down -v` during normal deployment.

The current VM has a small data disk. Run `06_zoekt_status.sh` and inspect free
space before image builds or corpus reindexing.

## Canonical workflow

The numbered scripts hide platform-specific Compose overlays and data paths.

Development:

```bash
./04_zoekt_start.sh --build
./06_zoekt_status.sh
./05_zoekt_stop.sh
```

Production release:

```bash
git push origin feat/google-analytics
ssh sanchaya.rasowshi.us
cd ~/sg/sanchaya-zoekt
git status --short --branch
git pull --ff-only origin feat/google-analytics
./04_zoekt_start.sh
./06_zoekt_status.sh
```

Use `./04_zoekt_start.sh --build` only when the Dockerfile or image dependencies
changed. Do not stop the service before an ordinary release; the start script
reconciles the running project. `05_zoekt_stop.sh` is for deliberate shutdown
or maintenance.

## Choose the correct update path

### Template or long-running service change

For templates or service configuration that does not affect indexed content,
recreate only the long-running services:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  up -d --no-deps --force-recreate zoekt-webserver caddy

./06_zoekt_status.sh
```

If the Dockerfile or compiled Zoekt binary changed, use
`./04_zoekt_start.sh --build` instead.

### Caddy-only route change

Validate the source configuration, then recreate only Caddy:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  config --quiet

sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  up -d --no-deps --force-recreate caddy
```

A Caddy-only change does not require a Zoekt reindex or retrieval vector
rebuild.

### Sanchaya corpus refresh

Run the one-shot indexer and restart the webserver after success:

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

./06_zoekt_status.sh
```

The indexer clones or fast-forwards `https://github.com/cahcblr/sanchaya.git`
and indexes `main`. Success requires a zero exit status, a consistent current
shard set, and no temporary index files.

### Patra Darpan retrieval or MCP change

Deploy the Patra Darpan project from its own checkout and Makefile. Recreate
Sanchaya Caddy only when `config/Caddyfile.prod` changed. Do not run the Zoekt
indexer merely because MCP, OAuth, Qdrant, or retrieval code changed.

## Verification

Start with:

```bash
./06_zoekt_status.sh
```

Expected long-running services:

```text
zoekt-caddy      Up
zoekt-webserver  Up
```

An indexer launched by the normal start path should finish as `Exited (0)`. An
indexer launched with `run --rm` disappears after successful completion.

Verify the public surface:

```bash
curl -sS -o /dev/null -w 'UI %{http_code}\n' \
  https://sanchaya.rasowshi.us/

curl -sS -o /dev/null -w 'SEARCH %{http_code}\n' \
  'https://sanchaya.rasowshi.us/search?q=%E0%A4%A4%E0%A4%BF%E0%A4%AE%E0%A4%BF%E0%A4%B0%E0%A4%BE'

curl -sS -o /dev/null -w 'API %{http_code}\n' \
  https://sanchaya.rasowshi.us/api/search
```

UI and search should return `200`; public API should return `404`.

When Patra Darpan retrieval is deployed, additionally verify:

- the OAuth discovery document is valid;
- unauthenticated `/mcp` returns `401`;
- an allowlisted client can initialize MCP and call a tool; and
- Patra Darpan backend smoke checks reach private Zoekt RPC.

## New VM setup

1. Clone the repository to `~/sg/sanchaya-zoekt`.
2. Run `01_docker_install.sh`.
3. Attach and prepare persistent storage with `02_disk_setup.sh`.
4. Run `03_zoekt_prep.sh`.
5. Confirm DNS and inbound ports 80/443.
6. Run `04_zoekt_start.sh --build`.
7. Wait for the indexer and run `06_zoekt_status.sh` plus the smoke checks.

The Patra Darpan companion is deployed separately after the
`sanchaya-zoekt_default` network exists.

## Troubleshooting

### Caddy returns 502

Inspect both the gateway and the intended upstream:

```bash
docker logs zoekt-caddy
docker logs zoekt-webserver
docker network inspect sanchaya-zoekt_default
```

For `/mcp`, confirm the Patra Darpan OAuth MCP container is attached to the
network. For the search UI, confirm `zoekt-webserver` is healthy.

### Indexer fails for disk space

Stop before deleting data. Inspect:

```bash
./06_zoekt_status.sh
docker system df
df -h /mnt
```

Builder-cache cleanup may be safe after inspection. Do not broadly prune
images, remove volumes, or delete the current shard set without a specific
recovery plan.

### Indexer fails after writing temporary shards

Keep the last known-good shards until the failure is understood. Confirm the
indexer exit status and temporary-file count. Remove only identified failed
temporary artifacts, then rerun the one-shot indexer.

## Rollback

1. Identify the last reviewed Sanchaya-Zoekt commit.
2. Move the production checkout to that commit or branch using a non-destructive
   Git operation appropriate to the incident.
3. Recreate only affected long-running services.
4. Reindex only if the rollback changes indexer behavior or the intended
   Sanchaya revision.
5. Run status and public smoke checks.

Rollback of Patra Darpan retrieval is handled in its repository. The two
projects share a network contract but retain independent source and release
lifecycles.
