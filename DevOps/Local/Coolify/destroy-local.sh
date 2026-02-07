#!/usr/bin/env bash
set -e

BASE_DIR="$HOME/runtime_data/delete_me_later/coolify/coolify-local"

echo "⚠️ Stopping Coolify containers..."
docker compose \
  -f DevOps/Local/Coolify/docker-compose.yml \
  down -v --remove-orphans

echo "⚠️ Removing local runtime data..."
rm -rf "$BASE_DIR"

echo "⚠️ Docker network cleanup..."
docker network rm coolify 2>/dev/null || true

echo "🧹 Local Coolify runtime destroyed"
