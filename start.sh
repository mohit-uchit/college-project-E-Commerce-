#!/usr/bin/env bash
set -euo pipefail

echo "Building frontend..."
cd frontened
npm ci
npm run build

echo "Starting backend..."
cd ../backend
npm ci

# If dist exists, backend will serve the frontend (server.js patched to do so)
node server.js
