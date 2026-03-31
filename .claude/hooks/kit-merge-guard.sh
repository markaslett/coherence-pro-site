#!/bin/bash
# kit-merge-guard.sh — PreToolUse hook (Bash matcher)
# Enforces /premerge gate before git merge or git push.
# Blocks the tool call if /premerge marker is absent.
# Deployed to .claude/hooks/ in all projects.

# Read tool input from stdin (Claude Code pipes JSON to hooks via stdin)
INPUT=$(cat)
COMMAND=$(printf '%s\n' "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null)

# Not a git merge or git push — exit immediately
if [[ "$COMMAND" != *"git merge"* ]] && [[ "$COMMAND" != *"git push"* ]]; then
    exit 0
fi

# Non-app repo exception: repos without .xcodeproj, Package.swift, or package.json
# have no build/test pipeline — skip premerge gate entirely.
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$REPO_ROOT" ]; then
    HAS_APP=false
    ls "$REPO_ROOT"/*.xcodeproj 1>/dev/null 2>&1 && HAS_APP=true
    [ -f "$REPO_ROOT/Package.swift" ] && HAS_APP=true
    [ -f "$REPO_ROOT/package.json" ] && HAS_APP=true
    if [ "$HAS_APP" = false ]; then
        exit 0
    fi
fi

# Ship commit-message exception: /ship writes a deterministic commit message.
# Allow the push without a premerge marker if HEAD is a build-bump commit.
HEAD_MSG=$(git log -1 --pretty=%s HEAD 2>/dev/null)
if [[ "$HEAD_MSG" == chore:\ bump\ build* ]] || [[ "$HEAD_MSG" == chore\(build\):* ]]; then
    exit 0
fi

# Ship diff exception: allow push if the only committed change in HEAD is a build number bump.
# Bug fix: compare HEAD~1 HEAD (committed only), not HEAD~1 (which includes working tree).
CHANGED_FILES=$(git diff HEAD~1 HEAD --name-only 2>/dev/null)
if [ -n "$CHANGED_FILES" ]; then
    NON_PBXPROJ=$(printf '%s\n' "$CHANGED_FILES" | grep -v '\.pbxproj$')
    if [ -z "$NON_PBXPROJ" ]; then
        # Only .pbxproj files changed — verify diff is build-number-only
        DIFF_LINES=$(git diff HEAD~1 HEAD -- '*.pbxproj' 2>/dev/null | grep '^[+-]' | grep -v '^[+-][+-][+-]' | grep -v 'CURRENT_PROJECT_VERSION')
        if [ -z "$DIFF_LINES" ]; then
            exit 0
        fi
    fi
fi

# Check for premerge marker
HEAD_SHA=$(git rev-parse HEAD 2>/dev/null)
MARKER="/tmp/kit-premerge-passed-${HEAD_SHA}.marker"

if [ ! -f "$MARKER" ]; then
    echo "BLOCKED: /premerge has not passed for this branch. Run /premerge before merging or pushing." >&2
    exit 2
fi

exit 0
