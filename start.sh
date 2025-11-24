#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")" || exit 1

echo "=== Starting E-Commerce Backend ==="

# Build frontend if directory exists
if [ -d "frontened" ]; then
  echo "📦 Building frontend..."
  cd frontened
  npm ci
  npm run build 2>/dev/null || echo "⚠️  Frontend build skipped"
  cd ..
fi

# Install and start backend
echo "🔧 Setting up backend..."
cd backend
npm ci --only=production

# Optional: seed database
if [ "${SEED_DB:-false}" = "true" ]; then
  echo "🌱 Seeding database..."
  node seedDatabase.js
fi

echo "🚀 Starting server..."
exec node server.js

