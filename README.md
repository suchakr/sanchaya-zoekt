# Sanchaya Zoekt Search

Sanchaya-Zoekt is the lexical-search service for the Sanchaya Indic text
corpus. It maintains a local Sanchaya checkout, builds Zoekt shards, and serves
a public Unicode-aware search interface.

## Components

| Service | Responsibility |
| --- | --- |
| `indexer` | Clone or fast-forward Sanchaya and build Zoekt shards |
| `zoekt-webserver` | Serve the search UI and private lexical RPC |
| `caddy` | Serve the public UI and dispatch production HTTPS routes |

The indexer is a one-shot job. The webserver and Caddy are long-running
services. Generated repositories and indexes live outside Git.

## Repository layout

| Path | Purpose |
| --- | --- |
| `01_docker_install.sh` | Docker installation check |
| `02_disk_setup.sh` | Host data-disk preparation |
| `03_zoekt_prep.sh` | Persistent directory preparation |
| `04_zoekt_start.sh` | Start or reconcile services; optionally build images |
| `05_zoekt_stop.sh` | Intentional full shutdown |
| `06_zoekt_status.sh` | Read-only Git, service, storage, and endpoint status |
| `docker-compose.yml` | Common services and indexer definition |
| `docker-compose.mac.yml` | macOS storage overlay |
| `docker-compose.override.yml` | Linux persistent-storage overlay |
| `docker-compose.prod.yml` | Production public port bindings |
| `config/Caddyfile` | Local `:6070` route |
| `config/Caddyfile.prod` | Production UI, MCP, and API boundary |

## Local development

Requirements: Docker Desktop and Git.

```bash
git clone https://github.com/suchakr/sanchaya-zoekt.git
cd sanchaya-zoekt
chmod +x *.sh
./01_docker_install.sh
./02_disk_setup.sh
./03_zoekt_prep.sh
./04_zoekt_start.sh --build
./06_zoekt_status.sh
```

Open `http://localhost:6070`. Stop the project intentionally with:

```bash
./05_zoekt_stop.sh
```

Use `--build` on first start or after Dockerfile/dependency changes. A normal
restart does not require it.

## Normal operation

The numbered scripts select the correct macOS or Linux Compose overlays:

```bash
./04_zoekt_start.sh
./06_zoekt_status.sh
./05_zoekt_stop.sh
```

`04_zoekt_start.sh` starts the one-shot indexer as well as the long-running
services. During indexing the indexer may be `Up`; success is `Exited (0)`.

For production release, corpus-refresh, verification, and rollback procedures,
see [`DEPLOYMENT.md`](DEPLOYMENT.md).

## Retrieval companion boundary

Patra Darpan provides the catalog, chunks, vector and entity indexes, and MCP
processes. This repository remains responsible for lexical indexing and the
production Caddy edge.

The integration contract is:

- Docker network: `sanchaya-zoekt_default`;
- private lexical service: `zoekt-webserver:6070` with RPC enabled;
- public Sanchaya search UI: `https://sanchaya.rasowshi.us/`;
- public OAuth MCP: `https://sanchaya.rasowshi.us/mcp`;
- public `/api/*`: denied by Caddy; and
- Qdrant, MCP container ports, and raw Zoekt RPC: private to Docker networks.

`config/Caddyfile.prod` is authoritative for public route dispatch. Retrieval
internals and MCP contracts are documented in the Patra Darpan repository under
`docs/retrieval/`.

## Data storage

Local development stores repositories and shards under `./data`. Production
uses `/mnt/docker-data/sanchaya-zoekt-data` through the Linux overlay.

Do not use `docker compose down -v` during normal operation. It would remove
named Caddy state, while broad cleanup can also endanger expensive index data.
Use `06_zoekt_status.sh` to inspect shard counts, temporary files, disk usage,
and the configured endpoint.

## CLI search

The browser is the normal interface. For direct local inspection, install the
Zoekt CLI and point it at the index directory:

```bash
go install github.com/sourcegraph/zoekt/cmd/zoekt@main
zoekt -index_dir ./data/index 'query'
```

The web JSON API is intended for the private retrieval adapter. Production
Caddy deliberately blocks public `/api/*` access.

## Sources of truth

| Fact | Source |
| --- | --- |
| Services, commands, and mounts | Compose files |
| Platform selection and routine lifecycle | numbered scripts |
| Public and private routes | Caddyfiles |
| Production procedure | `DEPLOYMENT.md` |
| Current repository and shard state | `06_zoekt_status.sh` |

## Content rights

Corpus rights remain with their respective sources.
