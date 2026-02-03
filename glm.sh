#!/bin/bash

# GLM - Claude Code Launcher with Model Selection and YOLO Mode
# Usage: glm [-m|--model MODEL] [-y|--yolo] [-h|--help] [--install]

CONFIG_FILE="$HOME/.glmrc"

# Check if config file exists and load token
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Set base environment
export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
export ANTHROPIC_API_KEY="$ANTHROPIC_AUTH_TOKEN"  # Use the token from config
export ANTHROPIC_AUTH_TOKEN="$ANTHROPIC_AUTH_TOKEN"  # Also set the original variable for status

# Validate required environment variables
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo "Error: ANTHROPIC_API_KEY environment variable is not set."
    echo ""
    echo "Get GLM Coding Plan: https://z.ai/subscribe?ic=YGTXTKNPPI"
    echo "Get your API key: https://z.ai/manage-apikey/apikey-list"
    echo ""
    echo "Please create ~/.glmrc with:"
    echo "ANTHROPIC_AUTH_TOKEN=your-api-key"
    exit 1
fi

# Parse arguments
MODEL=""
YOLO_MODE=false
SHOW_HELP=false
SHOW_INSTALL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -m|--model)
            MODEL="$2"
            shift 2
            ;;
        -y|--yolo)
            YOLO_MODE=true
            shift
            ;;
        -h|--help)
            SHOW_HELP=true
            shift
            ;;
        --install)
            SHOW_INSTALL=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use 'glm -h' for help"
            exit 1
            ;;
    esac
done

# Show install instructions if requested
if [ "$SHOW_INSTALL" = true ]; then
    echo "GLM Installation Instructions"
    echo "============================="
    echo ""
    echo "To install GLM globally on your system:"
    echo ""
    echo "1. Copy the script to /usr/local/bin:"
    echo "   sudo cp glm.sh /usr/local/bin/glm"
    echo ""
    echo "2. Make it executable:"
    echo "   sudo chmod +x /usr/local/bin/glm"
    echo ""
    echo "3. Test the installation:"
    echo "   glm -h"
    echo ""
    echo "After installation, you can run 'glm' from any directory."
    echo "To uninstall: sudo rm /usr/local/bin/glm"
    exit 0
fi

# Show help if requested
if [ "$SHOW_HELP" = true ]; then
    echo "GLM - Claude Code Launcher"
    echo ""
    echo "Usage:"
    echo "  glm                           Run with default models"
    echo "  glm -m MODEL                  Run with specific model for Sonnet and Opus"
    echo "  glm --model MODEL             Same as -m"
    echo "  glm -y                        Enable YOLO mode (dangerous - skips permissions)"
    echo "  glm --yolo                    Same as -y"
    echo "  glm -h                        Show this help"
    echo "  glm --install                 Show installation instructions"
    echo ""
    echo "Valid models: glm-4.5, glm-4.6, glm-4.7"
    echo ""
    echo "WARNING: YOLO mode (--yolo) disables all safety checks and allows"
    echo "Claude Code to execute commands, modify files, and delete data without"
    echo "prompts. Use with extreme caution!"
    echo ""
    echo "Examples:"
    echo "  glm"
    echo "  glm -m glm-4.5"
    echo "  glm -m glm-4.6 -y    # Use glm-4.6 with YOLO mode"
    echo "  glm --yolo --model glm-4.7"
    echo "  glm --install        # Show how to install globally"
    exit 0
fi

# Validate model if provided
if [ -n "$MODEL" ]; then
    case $MODEL in
        glm-4.5|glm-4.6|glm-4.7)
            export ANTHROPIC_DEFAULT_SONNET_MODEL="$MODEL"
            export ANTHROPIC_DEFAULT_OPUS_MODEL="$MODEL"
            ;;
        *)
            echo "Error: Invalid model '$MODEL'"
            echo "Valid models: glm-4.5, glm-4.6, glm-4.7"
            echo "Use 'glm -h' for help"
            exit 1
            ;;
    esac
fi

# Prepare Claude command
CLAUDE_CMD="claude"
if [ "$YOLO_MODE" = true ]; then
    CLAUDE_CMD="$CLAUDE_CMD --dangerously-skip-permissions"
    echo "WARNING: Running in YOLO mode - all safety checks disabled!"
fi

# Run Claude Code with debug output
echo "DEBUG: API_KEY starts with: ${ANTHROPIC_API_KEY:0:20}..."
echo "DEBUG: BASE_URL: $ANTHROPIC_BASE_URL"
echo "DEBUG: Running command: $CLAUDE_CMD"
echo "Running GLM..."

# Show all ANTHROPIC_* environment variables for debugging
echo "DEBUG ENV:"
env | grep ANTHROPIC | sort

exec $CLAUDE_CMD