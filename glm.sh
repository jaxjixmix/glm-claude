#!/bin/bash
set -euo pipefail

# GLM - Minimal Claude Code wrapper for Z.AI GLM models
CONFIG_FILE="$HOME/.glmrc"

# Source token config
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

# Set base GLM endpoint
export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
export ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN:-}"

# Handle -y shortcut for --dangerously-skip-permissions
if [[ " $* " == *" -y "* ]] || [[ " $* " == *" --yes "* ]]; then
    # Remove -y or --yes from arguments
    args=("${@/-y/}")
    args=("${args[@]/--yes/}")
    exec claude --dangerously-skip-permissions "${args[@]}"
else
    # Run claude with remaining args
    exec claude "$@"
fi
