#!/bin/bash

# GLM Installer
# Run with: curl -fsSL <url> | bash
# Or: bash install.sh

set -e

echo "GLM Installer"
echo "============="
echo ""

# Check if running on macOS or Linux
if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This installer only supports macOS and Linux"
    exit 1
fi

echo "Installing GLM..."

# For local testing - copy from current directory
# In production, this would download from URL
if [ -f "./glm.sh" ]; then
    echo "Using local glm.sh..."
    GLM_SOURCE="./glm.sh"
else
    # Fallback to download (replace with actual URL when hosted)
    GLM_URL="https://raw.githubusercontent.com/jaxjixmix/glm-claude/main/glm.sh"
    echo "Downloading GLM script..."
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    if ! curl -fsSL "$GLM_URL" -o "$TEMP_DIR/glm.sh"; then
        echo "Error: Failed to download GLM script"
        echo "Please check your internet connection and try again"
        exit 1
    fi
    GLM_SOURCE="$TEMP_DIR/glm.sh"
fi

# Determine install directory
# Use user directory to avoid requiring sudo/password
USER_BIN_DIR="$HOME/.local/bin"

# Create directory if it doesn't exist
if [ ! -d "$USER_BIN_DIR" ]; then
    echo "Creating $USER_BIN_DIR..."
    mkdir -p "$USER_BIN_DIR"
fi

# Install to user directory (no password required)
echo "Installing to $USER_BIN_DIR..."
if ! cp "$GLM_SOURCE" "$USER_BIN_DIR/glm"; then
    echo "Error: Failed to install GLM"
    exit 1
fi

# Make sure it's executable
chmod +x "$USER_BIN_DIR/glm"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$USER_BIN_DIR:"* ]]; then
    echo ""
    echo "⚠️  WARNING: $USER_BIN_DIR is not in your PATH"
    echo ""
    echo "Add the following to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo ""
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "Then restart your shell or run: source ~/.zshrc (or ~/.bashrc)"
fi

echo ""
echo "✓ GLM has been successfully installed to $USER_BIN_DIR/glm"
echo ""
echo "Usage:"
echo "  glm -h              # Show help"
echo "  glm                 # Run with default settings"
echo "  glm -m glm-4.5      # Use specific model"
echo ""
echo "Before using, set your API key:"
echo "  export ANTHROPIC_API_KEY='your-api-key'"
echo "  # Get it from: https://console.anthropic.com/"
echo ""
echo "To uninstall: rm $USER_BIN_DIR/glm"
echo ""
echo "Happy coding with GLM! 🚀"