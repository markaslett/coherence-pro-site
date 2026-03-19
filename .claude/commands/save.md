<!-- version: 1.1 -->

End this session. Run the /save protocol from CLAUDE.md Section 0.

## Primary (dev-tools available)

1. Run /summary (unchanged — Claude generates session recap).

2. Check gates:
   - Reconciliation [!] items from /summary -> require "save anyway" to proceed.
   - Unprocessed INPUT.md -> warn.
   - Open P0 issues -> warn.

3. Screenshots: if View files in session diff, take before/after.

4. Write session handoff:
   Claude determines content (AI work), then:
   `bash ~/projects/claude-dev-tools/session/handoff.sh --start-here "..." --waiting "..." --do-not-forget "..."`
   Pipe-separated multi-items for --waiting and --do-not-forget.

5. Pre-save checks:
   - DECISIONS.md audit: any decisions made but not recorded?
   - Convention/architecture check on changed files.
   - If 5+ files changed: invoke Documenter subagent (pre-save hook).

6. Worktree cleanup: check for orphaned worktrees, clean if found.

7. Commit and push:
   `bash ~/projects/claude-dev-tools/session/checkpoint.sh --commit --push --message "feat(scope): description" --json`
   Read JSON: committed, commit_sha, files_committed, pushed, issues_closed,
   auto_close_candidates[], metrics: { commits, files_changed, lines_added, lines_removed, agents_used }.

8. Auto-close candidates:
   checkpoint.sh includes auto_close_candidates[] from auto-close.sh --check.
   Each candidate has: { issue_number, title, evidence, confidence }.
   Present candidates to Claude for confirmation — do NOT auto-close blindly.
   For each candidate with confidence == "high": close via GitHub MCP.
   For "medium" confidence: present to Mark for approval.
   For "low" confidence: skip, note in summary.

9. Metrics captured automatically by checkpoint.sh (session duration, commits,
   files changed, lines, agent invocations). No action needed — stored in CREW-LOG.md.

9.5. Run: `bash ~/projects/claude-dev-tools/session/debt-score.sh --json`
   Read JSON: score, delta, breakdown. Report: "Debt: [N] points ([+/-M] from last session)."
   Fallback: compute manually — deferred P2s (1pt), files >250 lines (1pt), stale brain >14d (2pt),
   TODOs >5 sessions (1pt). Store in docs/brain/METRICS.md.

9.6. Run: `bash ~/projects/claude-dev-tools/session/session-log.sh --summary "[task description]"`
   Appends session entry to SESSION-LOG.md. Fallback: write manually — date, task, decisions, files changed.

10. Release lock:
    `bash ~/projects/claude-dev-tools/session/lock.sh release`
    Report: "Saved. [N] files. [hash]. Lock released. Closed: #N, #N."

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."

1. /summary. 2. Gates: reconciliation [!], INPUT, P0. 3. Screenshots.
3.5. Pre-save: DECISIONS.md audit, SESSION HANDOFF (write START HERE, WAITING FOR MARK,
DO NOT FORGET, CREW ACTIVITY to STATUS.md manually), pre-save hook (Documenter on 5+ files).
4. Convention/architecture check. 5. Worktree cleanup.
6. git add [files] && git commit -m "..." && git push.
   Scan commits for #NNN, close via GitHub MCP. Update ISSUES.md.
7. Clear SESSION-LOCK.md. Report: "Saved. [N] files. [hash]. Lock released."

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/save","status":"complete","emoji":":floppy_disk:","summary":"Committed [hash] — [N] files, [N] issues closed, lock released","detail_lines":["[commit message first line]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
