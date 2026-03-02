# openclaw-workspace

A workspace for building and running [OpenClaw](https://github.com/openclaw/openclaw) — a self-hosted, multi-channel AI gateway.

## Quick start

### Option A — automated setup (local build)

```bash
bash setup.sh
```

This script clones the openclaw source, installs dependencies, builds the project, and creates a `.env` file from the template.

### Option B — Docker (pre-built image)

```bash
cp .env.example .env
# Edit .env: set OPENCLAW_GATEWAY_TOKEN and at least one AI provider key
docker compose up -d
```

The gateway will be reachable at `http://localhost:18789`.

## Configuration

All settings are in `.env` (created from `.env.example`). The minimum required values are:

| Variable | Description |
|---|---|
| `OPENCLAW_GATEWAY_TOKEN` | Auth token for the gateway API (generate with `openssl rand -hex 32`) |
| `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` / `GEMINI_API_KEY` | At least one AI model provider key |

Optional channel tokens (Telegram, Discord, Slack, etc.) can be added at any time.

## CI / Build workflow

The repository includes a GitHub Actions workflow at `.github/workflows/build.yml` that automatically builds openclaw on every push and pull request. You can also trigger a manual build from the **Actions** tab and optionally specify a different `openclaw/openclaw` branch, tag, or commit SHA to build.

Built artifacts (`dist/` and `openclaw.mjs`) are uploaded and retained for 7 days.

## Directory layout

```
.
├── .env.example           # Configuration template
├── .github/
│   └── workflows/
│       └── build.yml      # CI workflow
├── docker-compose.yml     # Docker Compose configuration
├── setup.sh               # Local bootstrap script
├── config/                # Runtime config dir (created by setup.sh / Docker)
└── workspace/             # OpenClaw agent workspace (created by setup.sh / Docker)
```

## Links

- OpenClaw docs: <https://docs.openclaw.ai>
- OpenClaw source: <https://github.com/openclaw/openclaw>
