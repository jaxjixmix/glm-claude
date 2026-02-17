# GLM - Claude Code Launcher

A minimal command-line wrapper for launching Claude Code with Z.AI GLM models.

## Installation

Install GLM globally with a single command (no password required):

```bash
curl -fsSL https://raw.githubusercontent.com/jaxjixmix/glm-claude/main/install.sh | bash
```

The installer installs to `~/.local/bin/`. If this directory isn't in your PATH, the installer will show you how to add it.

## Usage

```bash
# Run Claude Code with GLM models
glm

# Pass any claude CLI arguments
glm --help
glm -c "your prompt"
```

## Features

- **Simple Wrapper**: Sets GLM API endpoint and passes all arguments to Claude Code
- **Secure Token Storage**: API tokens saved securely in `~/.glmrc`
- **Cross-Platform**: Works on macOS and Linux

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
