#!/bin/bash
# kit-merge-guard.sh — PreToolUse hook (Bash matcher)
# Enforces /premerge gate before git merge or git push.
# Blocks the tool call if /premerge marker is absent.
# Deployed to .claude/hooks/ in all projects.

# Extract command from tool input
COMMAND=$(printf '%s\n' "$CLAUDE_TOOL_INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('command',''))" 2>/dev/null)

# Not a git merge or git push — exit immediately
if [[ "$COMMAND" != *"git merge"* ]] && [[ "$COMMAND" != *"git push"* ]]; then
    exit 0
fi

# Check for premerge marker
HEAD_SHA=$(git rev-parse HEAD 2>/dev/null)
MARKER="/tmp/kit-premerge-passed-${HEAD_SHA}.marker"

if [ ! -f "$MARKER" ]; then
    echo "BLOCKED: /premerge has not passed for this branch. Run /premerge before merging or pushing." >&2
    exit 2
fi

exit 0
