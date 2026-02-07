# Coolify-Runtime

A local development environment for [Coolify](https://coolify.io/) - a self-hostable, open-source alternative to Heroku, Netlify, and Vercel.

## Overview

This project provides Docker Compose-based local setup for running Coolify with:

- **Coolify** - Main application (accessible at `http://localhost:8000`)
- **PostgreSQL 15** - Database backend
- **Redis 7** - Caching and queue management

All runtime data is stored in `~/runtime_data/delete_me_later/coolify/coolify-local/`.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- [Node.js](https://nodejs.org/) (for npm scripts)
- macOS/Linux environment (bash scripts)

## Quick Start

### 1. Setup Local Coolify

```bash
npm run coolify:setup-local
```

This command will:
- Create necessary directories for data persistence
- Create a Docker network named `coolify`
- Generate secure secrets (APP_KEY, DB_PASSWORD, REDIS_PASSWORD)
- Pull and start all containers

Once complete, open **http://localhost:8000** in your browser.

### 2. Destroy Local Coolify

```bash
npm run coolify:setup-local-destroy
```

This command will:
- Stop and remove all Coolify containers
- Remove all volumes and orphan containers
- Delete all local runtime data
- Remove the Docker network

## Available Commands

| Command | Description |
|---------|-------------|
| `npm run coolify:setup-local` | Start Coolify locally with all dependencies |
| `npm run coolify:setup-local-destroy` | Stop and remove all Coolify resources |

## Project Structure

```
├── DevOps/
│   └── Local/
│       └── Coolify/
│           ├── docker-compose.yml   # Docker services configuration
│           ├── env.template         # Environment variables template
│           ├── setup-local.sh       # Setup script
│           └── destroy-local.sh     # Teardown script
├── package.json                     # NPM scripts
└── README.md
```

## Configuration

Environment variables are automatically generated during setup. The template is located at `DevOps/Local/Coolify/env.template`.

| Variable | Description |
|----------|-------------|
| `APP_KEY` | Laravel application key (auto-generated) |
| `DB_PASSWORD` | PostgreSQL password (auto-generated) |
| `REDIS_PASSWORD` | Redis password (auto-generated) |

## Data Persistence

All persistent data is stored at:
```
~/runtime_data/delete_me_later/coolify/coolify-local/
├── data/
│   ├── applications/
│   ├── backups/
│   ├── databases/
│   ├── postgres/
│   ├── proxy/
│   ├── redis/
│   ├── services/
│   ├── ssh/
│   └── webhooks-during-maintenance/
└── source/
    └── .env
```

## License

See [LICENSE](LICENSE) for details.