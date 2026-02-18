#!/bin/bash
set -euo pipefail

# glm-docker - Create Dockerfile and docker-compose.glm.yml for running Claude Code with GLM
DOCKERFILE="Dockerfile"
COMPOSE_FILE="docker-compose.glm.yml"

# Check if files already exist
if [ -f "$DOCKERFILE" ] || [ -f "$COMPOSE_FILE" ]; then
    echo "Error: Docker files already exist in current directory"
    echo "Please remove them or run this command in a different directory"
    exit 1
fi

# Check if ~/.glmrc exists
if [ ! -f "$HOME/.glmrc" ]; then
    echo "Warning: ~/.glmrc not found"
    echo "You'll need to set ANTHROPIC_AUTH_TOKEN in the environment or .env file"
fi

# Create Dockerfile
cat > "$DOCKERFILE" << 'EOF'
FROM node:20-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI via npm
RUN npm install -g @anthropic-ai/claude-code

# Create non-root user for running Claude Code
RUN useradd -m -s /bin/bash claude && \
    mkdir -p /workspace && \
    chown -R claude:claude /workspace

# Set up workspace
WORKDIR /workspace

# Set default environment variables
ENV ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic

# Switch to non-root user
USER claude

# Default to bash shell
CMD ["/bin/bash"]
EOF

# Create docker-compose.glm.yml
cat > "$COMPOSE_FILE" << 'EOF'
services:
  claude-glm:
    build: .
    container_name: claude-glm
    environment:
      - ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic
      - ANTHROPIC_AUTH_TOKEN=${ANTHROPIC_AUTH_TOKEN:-}
    working_dir: /workspace
    volumes:
      - .:/workspace
    stdin_open: true
    tty: true
EOF

# Also create a helper script that sources ~/.glmrc
cat > glm-docker-env.sh << 'EOFSCRIPT'
#!/bin/bash
# Source ~/.glmrc to get the token
[ -f "$HOME/.glmrc" ] && source "$HOME/.glmrc"
# Export the token so docker-compose can see it
export ANTHROPIC_AUTH_TOKEN
# Run docker-compose with the environment
docker compose -f docker-compose.glm.yml "$@"
EOFSCRIPT

chmod +x glm-docker-env.sh

echo "✓ Created $DOCKERFILE, $COMPOSE_FILE, and glm-docker-env.sh"
echo ""
echo "To build and run Claude Code with GLM:"
echo "  ./glm-docker-env.sh build    # Build the Docker image"
echo "  ./glm-docker-env.sh run --rm claude-glm claude"
echo ""
echo "Or use docker compose directly (if ANTHROPIC_AUTH_TOKEN is set):"
echo "  docker compose -f docker-compose.glm.yml build"
echo "  docker compose -f docker-compose.glm.yml run --rm claude-glm claude"
echo ""
echo "Tip: The glm-docker-env.sh helper automatically sources ~/.glmrc"
