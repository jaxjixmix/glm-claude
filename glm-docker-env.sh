#!/bin/bash
# Source ~/.glmrc to get the token
[ -f "$HOME/.glmrc" ] && source "$HOME/.glmrc"
# Export the token so docker-compose can see it
export ANTHROPIC_AUTH_TOKEN
# Run docker-compose with the environment
docker compose -f docker-compose.glm.yml "$@"
