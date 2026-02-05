# Add Prompt Flag Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add `-p`/`--prompt` flag to pass an initial prompt to Claude while keeping the session interactive

**Architecture:** Add PROMPT variable and argument parsing, then conditionally pipe prompt via stdin using `{ echo "$PROMPT"; cat; } | claude ...` pattern

**Tech Stack:** Bash scripting, POSIX shell compatibility

---

### Task 1: Add PROMPT variable initialization

**Files:**
- Modify: `glm.sh:52-56`

**Step 1: Add PROMPT variable after existing variables**

Find the variable initialization section (around line 52) and add PROMPT variable:

```bash
# Parse arguments
MODEL=""
YOLO_MODE=false
SHOW_HELP=false
SHOW_INSTALL=false
SHOW_MODELS=false
PROMPT=""    # Add this line
```

**Step 2: Verify the file syntax**

Run: `bash -n glm.sh`
Expected: No syntax errors

**Step 3: Commit**

```bash
git add glm.sh
git commit -m "Add PROMPT variable initialization

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

### Task 2: Add -p/--prompt argument parsing

**Files:**
- Modify: `glm.sh:58-86`

**Step 1: Add case for -p/--prompt in the while loop**

Add this case in the argument parsing while loop (after the --models case, before the *):

```bash
        -p|--prompt)
            PROMPT="$2"
            shift 2
            ;;
```

**Step 2: Verify the file syntax**

Run: `bash -n glm.sh`
Expected: No syntax errors

**Step 3: Test help still works**

Run: `./glm.sh --help | head -20`
Expected: Help output displays correctly

**Step 4: Commit**

```bash
git add glm.sh
git commit -m "Add -p/--prompt argument parsing

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

### Task 3: Add validation for missing prompt argument

**Files:**
- Modify: `glm.sh:58-86`

**Step 1: Add validation check in the -p|--prompt case**

Modify the case to check if PROMPT is empty after shift:

```bash
        -p|--prompt)
            if [ -z "$2" ]; then
                echo "Error: -p/--prompt requires an argument"
                echo "Use 'glm -h' for help"
                exit 1
            fi
            PROMPT="$2"
            shift 2
            ;;
```

**Step 2: Verify the file syntax**

Run: `bash -n glm.sh`
Expected: No syntax errors

**Step 3: Test missing argument error**

Run: `./glm.sh -p`
Expected: Error message "Error: -p/--prompt requires an argument"

**Step 4: Commit**

```bash
git add glm.sh
git commit -m "Add validation for missing prompt argument

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

### Task 4: Update help text to include -p flag

**Files:**
- Modify: `glm.sh:128-155`

**Step 1: Add -p/--prompt to help output**

Add these lines in the help section (after the --models line, before the empty line):

```bash
echo "  glm -p PROMPT                 Start with an initial prompt"
echo "  glm --prompt PROMPT           Same as -p"
```

**Step 2: Verify the help output**

Run: `./glm.sh --help | grep -A1 "prompt"`
Expected: Shows the new prompt usage lines

**Step 3: Commit**

```bash
git add glm.sh
git commit -m "Add -p/--prompt to help documentation

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

### Task 5: Implement prompt piping logic

**Files:**
- Modify: `glm.sh:173-181`

**Step 1: Replace the simple exec with conditional prompt piping**

Replace the existing Claude command execution section:

Current code (lines 173-181):
```bash
# Prepare Claude command
CLAUDE_CMD="claude"
if [ "$YOLO_MODE" = true ]; then
    CLAUDE_CMD="$CLAUDE_CMD --dangerously-skip-permissions"
    echo "WARNING: Running in YOLO mode - all safety checks disabled!"
fi

echo "Running GLM..."
exec $CLAUDE_CMD
```

New code:
```bash
# Prepare Claude command
CLAUDE_CMD="claude"
if [ "$YOLO_MODE" = true ]; then
    CLAUDE_CMD="$CLAUDE_CMD --dangerously-skip-permissions"
    echo "WARNING: Running in YOLO mode - all safety checks disabled!"
fi

echo "Running GLM..."

# If prompt provided, pipe it and keep stdin open for interaction
if [ -n "$PROMPT" ]; then
    { echo "$PROMPT"; cat; } | $CLAUDE_CMD
else
    exec $CLAUDE_CMD
fi
```

**Step 2: Verify the file syntax**

Run: `bash -n glm.sh`
Expected: No syntax errors

**Step 3: Test normal operation (no prompt)**

Run: `./glm.sh --help`
Expected: Help still works, no errors

**Step 4: Commit**

```bash
git add glm.sh
git commit -m "Implement prompt piping with stdin kept open

Uses { echo \"\$PROMPT\"; cat; } pattern to send prompt
then keep session interactive.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

### Task 6: Update README.md documentation

**Files:**
- Modify: `README.md`

**Step 1: Add usage examples to Usage section**

Add after line 37 (after the `glm --models` example):

```bash
# Start with an initial prompt
glm -p "help me refactor this function"

# Combine model selection with prompt
glm -m glm-4.6 -p "add error handling"
```

**Step 2: Add -p to Features list**

Add after line 42 (after the "Model Selection" line):

```markdown
- **Initial Prompts**: Start conversations with `-p` to immediately begin working on a task
```

**Step 3: Add -p to Options table**

Add after line 54 (after the -m option line):

```markdown
  -p, --prompt PROMPT  Start with an initial prompt
```

**Step 4: Add examples to Options section**

Add after line 63 (after the `glm --models` example):

```bash
  glm -p "review my code"              # Start with initial prompt
  glm -m glm-4.5 -p "add tests"        # Combine with model selection
  glm --prompt "fix bug" -y            # Combine with YOLO mode
```

**Step 5: Commit**

```bash
git add README.md
git commit -m "Document -p/--prompt flag in README

Add usage examples, feature description, and options
documentation for the new prompt flag.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

### Task 7: Manual testing and verification

**Files:**
- Test: `glm.sh` (manual testing)

**Step 1: Test basic prompt usage**

Run: `./glm.sh -p "echo hello" --help`
Expected: Script shows help (prompt ignored by --help)

**Step 2: Test model selection with prompt**

Run: `./glm.sh -m glm-4.6 -p "test" --help`
Expected: Help shows, no errors

**Step 3: Test missing prompt argument**

Run: `./glm.sh -p`
Expected: "Error: -p/--prompt requires an argument"

**Step 4: Verify all help text includes new flag**

Run: `./glm.sh --help | grep prompt`
Expected: Shows -p/--prompt usage

**Step 5: Review README documentation**

Run: `cat README.md | grep -A2 -B2 "prompt"`
Expected: Documentation is clear and complete

**Step 6: Final commit**

```bash
git add -A
git commit -m "Complete -p/--prompt flag implementation

Feature complete with:
- Argument parsing and validation
- Prompt piping with interactive session
- Comprehensive documentation

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"
```

---

## Summary

This implementation adds the `-p`/`--prompt` flag to GLM, allowing users to pass an initial prompt that Claude immediately begins working on while keeping the session interactive.

**Key implementation details:**
- PROMPT variable initialized alongside other flags
- Argument parsing with validation for missing arguments
- Piping via `{ echo "$PROMPT"; cat; }` keeps stdin open after sending prompt
- Full documentation in help text and README

**Testing approach:**
- Manual verification of each flag combination
- Syntax checking with `bash -n`
- Help text verification
