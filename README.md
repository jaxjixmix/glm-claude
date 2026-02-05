# GLM - Claude Code Launcher

A command-line tool for launching Claude Code with Z.AI GLM models, featuring model selection, YOLO mode, and secure token management.

## Installation

Install GLM globally with a single command (no password required):

```bash
curl -fsSL https://raw.githubusercontent.com/jaxjixmix/glm-claude/main/install.sh | bash
```

The installer installs to `~/.local/bin/`. If this directory isn't in your PATH, the installer will show you how to add it.

## Usage

```bash
# Show help
glm -h

# Run with default model (glm-4.7)
glm

# Use specific model for Sonnet and Opus
glm -m glm-4.5
glm -m glm-4.6
glm -m glm-4.7

# Enable YOLO mode (dangerous - skips permissions)
glm -y

# Combine model selection with YOLO mode
glm -m glm-4.6 -y

# Show available models with descriptions
glm --models

# Start with an initial prompt
glm -p "help me refactor this function"

# Combine model selection with prompt
glm -m glm-4.6 -p "add error handling"
```

## Features

- **Model Selection**: Override default models with glm-4.5, glm-4.6, or glm-4.7
- **Initial Prompts**: Start conversations with `-p` to immediately begin working on a task
- **YOLO Mode**: Disable safety checks with `--dangerously-skip-permissions`
- **Secure Token Storage**: API tokens saved securely in `~/.glmrc`
- **Cross-Platform**: Works on macOS and Linux
- **First-Run Setup**: Automatic token configuration on first use

## Options

```
Usage: glm [OPTIONS]

Options:
  -m, --model MODEL    Set model for Sonnet and Opus (glm-4.5, glm-4.6, glm-4.7)
  -p, --prompt PROMPT  Start with an initial prompt
  -y, --yolo          Enable YOLO mode (skips permissions - use with caution!)
  -h, --help          Show this help message
  --install           Show installation instructions
  --models            Show available models with descriptions

Examples:
  glm                          # Default usage
  glm -m glm-4.5              # Use glm-4.5 for Sonnet/Opus
  glm --model glm-4.6 -y      # Use glm-4.6 with YOLO mode
  glm --models                # Show available models
  glm -p "review my code"              # Start with initial prompt
  glm -m glm-4.5 -p "add tests"        # Combine with model selection
  glm --prompt "fix bug" -y            # Combine with YOLO mode
```

## Security Notes

- **YOLO Mode Warning**: The `--yolo` flag disables all Claude Code safety checks, allowing execution of commands, file modifications, and deletions without prompts. Use extremely cautiously!

- **Token Security**: Your Anthropic API token is stored securely in `~/.glmrc` with restricted permissions (600).

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

## Uninstallation

```bash
rm ~/.local/bin/glm
rm ~/.glmrc  # Optional: remove stored token
```

## License

MIT License - feel free to share and modify!