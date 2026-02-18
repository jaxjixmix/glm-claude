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
