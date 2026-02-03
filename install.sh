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
    GLM_URL="https://raw.githubusercontent.com/your-repo/glm/main/glm.sh"
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
if [[ "$OSTYPE" == "darwin"* ]]; then
    INSTALL_DIR="/usr/local/bin"
else
    INSTALL_DIR="/usr/local/bin"
fi

# Install to system
echo "Installing to $INSTALL_DIR..."
if ! sudo cp "$GLM_SOURCE" "$INSTALL_DIR/glm"; then
    echo "Error: Failed to install GLM"
    echo "You may need to run this script with sudo or enter your password when prompted"
    exit 1
fi

# Make sure it's executable
sudo chmod +x "$INSTALL_DIR/glm"

echo ""
echo "GLM has been successfully installed!"
echo ""
echo "Usage:"
echo "  glm -h              # Show help"
echo "  glm                 # Run with default settings"
echo "  glm -m glm-4.5      # Use specific model"
echo ""
echo "First run will prompt for your Anthropic API token."
echo "Happy coding with GLM! 🚀"