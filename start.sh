#!/usr/bin/env bash
set -euo pipefail

# Railway/Render-ready startup script
# - Builds frontend if present
# - Installs backend dependencies
# - Optionally seeds the database when SEED_DB=true
# - Starts the backend with node server.js

cd "$(dirname "$0")" || exit 1

echo "=== Starting application ==="

# Ensure Node is in PATH (Railway may need this)
export PATH="/usr/local/bin:/usr/bin:/bin:$PATH"

# Find node in common locations
NODE_BIN=""
for path in /nix/store/*/bin/node /usr/bin/node /usr/local/bin/node /opt/homebrew/bin/node; do
  if [ -x "$path" ] 2>/dev/null; then
    NODE_BIN="$path"
    break
  fi
done

# Try 'which' as fallback
if [ -z "$NODE_BIN" ]; then
  NODE_BIN=$(which node 2>/dev/null || true)
fi

# If still not found, try without checking executability (Railway edge case)
if [ -z "$NODE_BIN" ]; then
  NODE_BIN=$(command -v node 2>/dev/null || echo "")
fi

if [ -z "$NODE_BIN" ] || ! "$NODE_BIN" --version >/dev/null 2>&1; then
  echo "ERROR: Node.js not found. Available in PATH:"
  echo $PATH
  exit 1
fi

echo "Node: $("$NODE_BIN" -v)"
echo "NPM: $(npm --version)"

# Build frontend if present
FRONT_DIR=""
if [ -d "frontened" ]; then
  FRONT_DIR="frontened"
elif [ -d "frontend" ]; then
  FRONT_DIR="frontend"
fi

if [ -n "$FRONT_DIR" ]; then
  echo "Building frontend in $FRONT_DIR..."
  cd "$FRONT_DIR"
  npm ci
  if npm run build 2>/dev/null; then
    echo "✓ Frontend built successfully"
  else
    echo "⚠ Frontend build skipped (no build script or failed)"
  fi
  cd - >/dev/null
fi

# Install and start backend
echo "Setting up backend..."
cd backend

npm ci --only=production

# Optional: seed database
if [ "${SEED_DB:-false}" = "true" ]; then
  echo "Seeding database..."
  node seedDatabase.js
fi

echo "Starting backend server..."
exec node server.js

