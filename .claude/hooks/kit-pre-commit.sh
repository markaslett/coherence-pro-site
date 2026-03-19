#!/bin/bash
# kit-pre-commit.sh — PreToolUse hook (Bash matcher)
# Lightweight quality check before git commit.
# Complementary to /premerge, not a replacement — warns only, does not block.
# Deployed to .claude/hooks/ in all projects.

# Extract command from tool input
COMMAND=$(printf '%s\n' "$CLAUDE_TOOL_INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('command',''))" 2>/dev/null)

# Not a git commit — exit immediately
[[ "$COMMAND" == *"git commit"* ]] || exit 0

# Convention check script
CONV_CHECK="$HOME/projects/claude-dev-tools/scanning/convention-check.sh"

if [ -x "$CONV_CHECK" ]; then
    RESULT=$(bash "$CONV_CHECK" --quick 2>&1)
    if [ $? -ne 0 ] && [ -n "$RESULT" ]; then
        echo "kit-pre-commit: convention warnings (non-blocking):" >&2
        echo "$RESULT" >&2
    fi
fi

# Always exit 0 — warning only, /premerge is the real gate
exit 0
