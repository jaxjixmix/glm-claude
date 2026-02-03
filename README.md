# GLM - Claude Code Launcher

A command-line tool for launching Claude Code with Z.AI GLM models, featuring model selection, YOLO mode, and secure token management.

## Installation

Install GLM globally with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/jaxjixmix/glm-claude/main/install.sh | bash
```

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
```

## Features

- **Model Selection**: Override default models with glm-4.5, glm-4.6, or glm-4.7
- **YOLO Mode**: Disable safety checks with `--dangerously-skip-permissions`
- **Secure Token Storage**: API tokens saved securely in `~/.glmrc`
- **Cross-Platform**: Works on macOS and Linux
- **First-Run Setup**: Automatic token configuration on first use

## Options

```
Usage: glm [OPTIONS]

Options:
  -m, --model MODEL    Set model for Sonnet and Opus (glm-4.5, glm-4.6, glm-4.7)
  -y, --yolo          Enable YOLO mode (skips permissions - use with caution!)
  -h, --help          Show this help message
  --install           Show installation instructions

Examples:
  glm                          # Default usage
  glm -m glm-4.5              # Use glm-4.5 for Sonnet/Opus
  glm --model glm-4.6 -y      # Use glm-4.6 with YOLO mode
```

## Security Notes

- **YOLO Mode Warning**: The `--yolo` flag disables all Claude Code safety checks, allowing execution of commands, file modifications, and deletions without prompts. Use extremely cautiously!

- **Token Security**: Your Anthropic API token is stored securely in `~/.glmrc` with restricted permissions (600).

## Requirements

- Claude Code installed and available in PATH
- curl (for installation)
- sudo access (for global installation)

## Uninstallation

```bash
sudo rm /usr/local/bin/glm
rm ~/.glmrc  # Optional: remove stored token
```

## License

MIT License - feel free to share and modify!