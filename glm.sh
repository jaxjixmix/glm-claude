#!/bin/bash
set -euo pipefail

# GLM - Minimal Claude Code wrapper for Z.AI GLM models
CONFIG_FILE="$HOME/.glmrc"

# Source token config
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Set base GLM endpoint
export ANTHROPIC_BASE_URL="https://api.zai/api/anthropic"
export ANTHROPIC_API_KEY="${ANTHROPIC_AUTH_TOKEN:-}"

# Run claude with remaining args
exec claude "$@"
