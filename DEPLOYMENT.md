# Production deployment runbook

This runbook operates the Azure VM serving `https://sanchaya.rasowshi.us`.
The normal production checkout is `~/sg/sanchaya-zoekt`.

## Production contract

- `zoekt-caddy` is the only public entry point on ports 80 and 443.
- `zoekt-webserver` serves the UI and private RPC on the Docker network.
- `indexer` is a one-shot corpus refresh and shard build.
- Persistent repositories and shards live under
  the host-configured `ZOEKT_DATA_DIR`, normally
  `/srv/docker-data/sanchaya-zoekt-data`.
- The live path is stored in `/etc/sanchaya-zoekt/production.env`; Git pulls do
  not change it. Production scripts pass that env file to Compose.
- Docker's `data-root` is a separate host setting in
  `/etc/docker/daemon.json`. On this VM, `/mnt` is temporary Azure resource
  storage and must never hold persistent Docker or application data.
- The Patra Darpan retrieval project joins `sanchaya-zoekt_default`; this
  repository does not build or own Qdrant, retrieval releases, or MCP code.
- Never use `docker compose down -v` during normal deployment.

Check free space on `/srv` before image builds or corpus reindexing. Do not
assume `/mnt` is persistent, even if it has more free space.

## Canonical workflow

The numbered scripts hide platform-specific Compose overlays and data paths.

Development:

```bash
./04_zoekt_start.sh --build
./06_zoekt_status.sh
./05_zoekt_stop.sh
```

Production releases use `main`. Existing hosts on `feat/google-analytics`
can switch to `main` after confirming the checkout has no tracked changes.
Changing the checkout alone does not recreate services or rebuild indexes.
Before using Linux production scripts, ensure
`/etc/sanchaya-zoekt/production.env` exists and contains the single setting
`ZOEKT_DATA_DIR=/srv/docker-data/sanchaya-zoekt-data` (or the reviewed host path).
The tracked `zoekt.env.prod.example` is a template, not the live configuration.

Production release:

```bash
git push origin main
ssh sanchaya.rasowshi.us
cd ~/sg/sanchaya-zoekt
git status --short --branch
git fetch origin
git switch main
git pull --ff-only origin main
./06_zoekt_status.sh
```

After pulling, choose the narrow update path below. `04_zoekt_start.sh` brings
up the full Compose project, including the one-shot indexer; do not use it for a
routine UI/service update. `05_zoekt_stop.sh` is for deliberate full shutdown,
not a normal deploy step.

A Docker-root storage migration is not an ordinary release. Do not use
`04_zoekt_start.sh` for that cutover: its normal `up` includes the one-shot
indexer. Recreate only the reviewed long-running services with explicit
`--no-build --pull never`; leave index shards and the indexer untouched.

## Choose the correct update path

### Template or long-running service change

For a UI template under `config/templates/`, or service config that does not
affect indexed content, recreate only the webserver. Templates are bind-mounted;
this does not build an image or run the indexer:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose --env-file /etc/sanchaya-zoekt/production.env \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  up -d --no-deps --no-build --pull never --force-recreate zoekt-webserver

./06_zoekt_status.sh
```

If the Dockerfile or compiled Zoekt binary changed, build both image outputs,
but recreate only the webserver. This updates the next indexer's image without
running an index job:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose --env-file /etc/sanchaya-zoekt/production.env \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  build zoekt-webserver indexer

sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose --env-file /etc/sanchaya-zoekt/production.env \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  up -d --no-deps --no-build --pull never --force-recreate zoekt-webserver

./06_zoekt_status.sh
```

For a Caddy-only change, use the Caddy-only path below. Only a reviewed corpus
refresh runs `indexer`.

### Caddy-only route change

Validate the source configuration, then recreate only Caddy:

```bash
sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose --env-file /etc/sanchaya-zoekt/production.env \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  config --quiet

sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose --env-file /etc/sanchaya-zoekt/production.env \
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
  docker compose --env-file /etc/sanchaya-zoekt/production.env \
  -f docker-compose.yml \
  -f docker-compose.override.yml \
  -f docker-compose.prod.yml \
  run --rm --no-deps indexer

sudo env CADDYFILE=./config/Caddyfile.prod \
  docker compose --env-file /etc/sanchaya-zoekt/production.env \
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

There is no dedicated automated UI test suite. Before push, run
`git diff --check`; after pull, validate the production Compose config and use
the status and HTTP checks below. For a text/template edit, also verify the
changed text in the rendered UI; HTTP 200 alone does not prove the copy is
correct.

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
3. Configure Docker `data-root` at `/srv/docker-data` on persistent storage,
   preserving existing daemon settings. Do not run `02_disk_setup.sh` on Linux:
   its old implementation formatted `/dev/sdb` and mounted it under `/mnt`.
4. Create `/etc/sanchaya-zoekt/production.env` from
   `zoekt.env.prod.example`, with the reviewed persistent `ZOEKT_DATA_DIR`.
5. Run `03_zoekt_prep.sh`.
6. Confirm DNS and inbound ports 80/443.
7. For a new deployment, run `04_zoekt_start.sh --build`, wait for the indexer,
   then run `06_zoekt_status.sh` and the smoke checks.

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
df -h /srv /mnt
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
