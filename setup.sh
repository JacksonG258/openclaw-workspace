#!/usr/bin/env bash
# setup.sh — Bootstrap the openclaw workspace
#
# Usage:
#   bash setup.sh

set -euo pipefail

OPENCLAW_REF="${OPENCLAW_REF:-main}"
CLONE_DIR="${CLONE_DIR:-openclaw}"

echo "==> Setting up openclaw workspace (ref: $OPENCLAW_REF)"

# 1. Clone openclaw source (if not already present)
if [ ! -d "$CLONE_DIR" ]; then
  echo "==> Cloning openclaw/openclaw ($OPENCLAW_REF) into ./$CLONE_DIR ..."
  git clone --depth 1 --branch "$OPENCLAW_REF" https://github.com/openclaw/openclaw.git "$CLONE_DIR"
else
  echo "==> '$CLONE_DIR' already exists, skipping clone."
fi

# 2. Install Node.js dependencies
echo "==> Installing dependencies with pnpm ..."
(
  cd "$CLONE_DIR"
  corepack enable
  corepack prepare pnpm@latest --activate
  pnpm install --frozen-lockfile
)

# 3. Build
echo "==> Building ..."
(cd "$CLONE_DIR" && pnpm build)

# 4. Copy .env template if not present
if [ ! -f .env ]; then
  echo "==> Creating .env from .env.example ..."
  cp .env.example .env
  echo ""
  echo "  Edit .env and set at minimum:"
  echo "    OPENCLAW_GATEWAY_TOKEN=<your-random-token>"
  echo "    ANTHROPIC_API_KEY=<your-key>  (or another model provider key)"
  echo ""
fi

# 5. Create runtime directories used by docker-compose.yml
mkdir -p config workspace

echo ""
echo "Build complete!  Next steps:"
echo "  1. Edit .env with your API keys and gateway token."
echo "  2. Run the gateway:  docker compose up -d"
echo "  3. Or run locally:   cd $CLONE_DIR && node openclaw.mjs"
