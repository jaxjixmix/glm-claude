# GLM - Claude Code Launcher

A minimal command-line wrapper for launching Claude Code with Z.AI GLM models.

## Installation

Install GLM globally with a single command (no password required):

```bash
curl -fsSL https://raw.githubusercontent.com/jaxjixmix/glm-claude/main/install.sh | bash
```

The installer installs both `glm` and `glm-docker` to `~/.local/bin/`. If this directory isn't in your PATH, the installer will show you how to add it.

## Usage

```bash
# Run Claude Code with GLM models
glm

# Pass any claude CLI arguments
glm --help
glm -c "your prompt"

# Create docker-compose.yml in current directory
glm-docker
```

## Features

- **Simple Wrapper**: Sets GLM API endpoint and passes all arguments to Claude Code
- **Secure Token Storage**: API tokens saved securely in `~/.glmrc`
- **Cross-Platform**: Works on macOS and Linux
- **Docker Support**: Generate docker-compose.yml for containerized usage

## Setup

Before using GLM, you need to get your GLM API key:

**Get GLM Coding Plan:** https://z.ai/subscribe?ic=YGTXTKNPPI  
**Get your API key:** https://z.ai/manage-apikey/apikey-list

Create a `~/.glmrc` file with your API key:

```bash
echo "ANTHROPIC_AUTH_TOKEN=your-api-key-here" > ~/.glmrc
chmod 600 ~/.glmrc
```

GLM will automatically load your token from this file when you run it.

## Docker Support

**Quick Start with Docker:**

```bash
# 1. Install GLM (includes glm-docker command)
curl -fsSL https://raw.githubusercontent.com/jaxjixmix/glm-claude/main/install.sh | bash

# 2. Go to your project directory
cd /path/to/your/project

# 3. Create Docker files
glm-docker

# 4. Build the Docker image (only needed once per project)
./glm-docker-env.sh build

# 5. Run Claude Code in Docker
./glm-docker-env.sh run --rm claude-glm claude
```

**Advanced Usage:**

```bash
# Run with auto-confirmation (bypasses permission prompts)
./glm-docker-env.sh run --rm claude-glm ./glm.sh -y "your prompt"

# Or use docker compose directly (if ANTHROPIC_AUTH_TOKEN is set)
docker compose -f docker-compose.glm.yml run --rm claude-glm claude
```

The Docker setup:
- Creates `docker-compose.glm.yml` (won't conflict with your existing docker-compose files)
- Creates `glm-docker-env.sh` helper script that automatically sources `~/.glmrc`
- Installs the official `@anthropic-ai/claude-code` npm package
- Pre-configures the GLM API endpoint
- Mounts your current directory to `/workspace` in the container
- Runs as non-root user (required for `--dangerously-skip-permissions`)
- Your API token from `~/.glmrc` is automatically used

**Available flags:**
- `-y` or `--yes` - Skip permission prompts (useful for automated scripts)
- All standard Claude Code CLI flags are supported

**Optional alias** - Add to your `~/.zshrc` or `~/.bashrc`:
```bash
alias glm-docker-up='docker compose -f docker-compose.glm.yml'
# Then use: glm-docker-up run --rm claude-glm claude
```

## Uninstallation

```bash
rm ~/.local/bin/glm
rm ~/.local/bin/glm-docker
rm ~/.glmrc  # Optional: remove stored token
```

## License

MIT License - feel free to share and modify!
