End this session. Run the /save protocol from CLAUDE.md Section 0.

## Primary (dev-tools available)

1. Run /summary (unchanged — Claude generates session recap).

2. Check gates:
   - Reconciliation [!] items from /summary -> require "save anyway" to proceed.
   - Unprocessed FEEDBACK.md -> warn.
   - Open P0 issues -> warn.

3. Screenshots: if View files in session diff, take before/after.

4. Write session handoff:
   Claude determines content (AI work), then:
   `bash ~/projects/dev-tools/session/handoff.sh --start-here "..." --waiting "..." --do-not-forget "..."`
   Pipe-separated multi-items for --waiting and --do-not-forget.

5. Pre-save checks:
   - DECISIONS.md audit: any decisions made but not recorded?
   - Convention/architecture check on changed files.
   - If 5+ files changed: invoke Documenter subagent (pre-save hook).

6. Worktree cleanup: check for orphaned worktrees, clean if found.

7. Commit, push, release lock:
   `bash ~/projects/dev-tools/session/checkpoint.sh --commit --push --message "feat(scope): description" --json`
   Read JSON: committed, commit_sha, files_committed, pushed, issues_closed.
   Script auto-closes issues referenced by #NNN in commit messages.
   Then: `bash ~/projects/dev-tools/session/lock.sh release`
   Report: "Saved. [N] files. [hash]. Lock released. Closed: #N, #N."

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."

1. /summary. 2. Gates: reconciliation [!], FEEDBACK, P0. 3. Screenshots.
3.5. Pre-save: DECISIONS.md audit, SESSION HANDOFF (write START HERE, WAITING FOR MARK,
DO NOT FORGET, CREW ACTIVITY to STATUS.md manually), pre-save hook (Documenter on 5+ files).
4. Convention/architecture check. 5. Worktree cleanup.
6. git add [files] && git commit -m "..." && git push.
   Scan commits for #NNN, close via GitHub MCP. Update ISSUES.md.
7. Clear SESSION-LOCK.md. Report: "Saved. [N] files. [hash]. Lock released."
