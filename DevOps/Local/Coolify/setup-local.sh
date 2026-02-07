#!/usr/bin/env bash
set -e

BASE_DIR="$HOME/runtime_data/delete_me_later/coolify/coolify-local"
SOURCE_DIR="$BASE_DIR/source"
DATA_DIR="$BASE_DIR/data"
ENV_FILE="$SOURCE_DIR/.env"

echo "▶ Creating Coolify local runtime directories..."

mkdir -p \
  "$SOURCE_DIR" \
  "$DATA_DIR/app" \
  "$DATA_DIR/ssh" \
  "$DATA_DIR/applications" \
  "$DATA_DIR/databases" \
  "$DATA_DIR/backups" \
  "$DATA_DIR/services" \
  "$DATA_DIR/proxy" \
  "$DATA_DIR/webhooks-during-maintenance" \
  "$DATA_DIR/postgres" \
  "$DATA_DIR/redis"

echo "▶ Creating Docker network (if not exists)..."
docker network inspect coolify >/dev/null 2>&1 || docker network create coolify

echo "▶ Preparing environment file..."

# Create .env if missing
if [ ! -f "$ENV_FILE" ]; then
  cp DevOps/Local/Coolify/env.template "$ENV_FILE"
fi

# Ensure required secrets exist (idempotent & safe)
if ! grep -q '^APP_KEY=base64:' "$ENV_FILE"; then
  sed -i '' "s|^APP_KEY=.*|APP_KEY=base64:$(openssl rand -base64 32)|" "$ENV_FILE"
fi

if ! grep -q '^DB_PASSWORD=.' "$ENV_FILE"; then
  sed -i '' "s|^DB_PASSWORD=.*|DB_PASSWORD=$(openssl rand -base64 32)|" "$ENV_FILE"
fi

if ! grep -q '^REDIS_PASSWORD=.' "$ENV_FILE"; then
  sed -i '' "s|^REDIS_PASSWORD=.*|REDIS_PASSWORD=$(openssl rand -base64 32)|" "$ENV_FILE"
fi

echo "▶ Exporting environment variables for Docker Compose..."
set -a
source "$ENV_FILE"
set +a

# Final safety check
if [ -z "$DB_PASSWORD" ] || [ -z "$REDIS_PASSWORD" ]; then
  echo "❌ ERROR: DB_PASSWORD or REDIS_PASSWORD is still empty"
  exit 1
fi

echo "▶ Starting Coolify locally..."
docker compose \
  -f DevOps/Local/Coolify/docker-compose.yml \
  up -d --pull always

echo ""
echo "✅ Coolify is running"
echo "🌐 Open http://localhost:8000"
