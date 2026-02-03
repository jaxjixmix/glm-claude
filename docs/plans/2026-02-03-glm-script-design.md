# GLM Script Design Document

## Overview
Enhanced bash script for launching Claude Code with Z.AI models, featuring model selection, YOLO mode, and secure token management.

## Requirements
- Support model selection via -m/--model flags (glm-4.5, glm-4.6, glm-4.7)
- Add YOLO mode (--dangerously-skip-permissions) with safety warnings
- Secure token storage in ~/.glmrc with first-time setup
- Maintain backward compatibility with original script
- Provide comprehensive help and error handling

## Architecture
- Single bash script with getopts argument parsing
- Config file-based token management
- Conditional environment variable setting
- Dynamic command construction for Claude Code

## Components
1. Token Setup: First-run configuration with secure file storage
2. Argument Parsing: getopts for -m/--model, -y/--yolo, -h/--help
3. Validation: Model name checking, error messages
4. Environment Setup: Base URL + conditional model overrides
5. Command Execution: Dynamic claude command with flags

## Workflows
- Default: glm (no model overrides)
- Model: glm -m glm-4.5 (sets SONNET_MODEL and OPUS_MODEL)
- YOLO: glm -y (dangerous permissions mode)
- Combined: glm -m glm-4.6 -y (model + YOLO)
- Help: glm -h (usage information)

## Security Considerations
- API tokens stored in protected config file (chmod 600)
- YOLO mode includes prominent warnings
- Input validation prevents invalid model names
- No hardcoded secrets in script

## Implementation Notes
- Uses bash built-ins for maximum portability
- Error handling with clear user feedback
- Shareable design with automatic setup
- Compatible with existing Claude Code installations