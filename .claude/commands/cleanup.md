<!-- version: 1.0 -->

Scan project root for misplaced files and propose reorganization.
Mark approves before anything moves.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/scanning/cleanup.sh --json`
Read JSON: misplaced array (path, suggested, reason), large_files, total_findings.

If total_findings == 0: "Project root is clean. No action needed."

Present using the CLEANUP REPORT template below.
Wait for Mark's approval. On approve: `bash ~/projects/claude-dev-tools/scanning/cleanup.sh --fix`

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."

1. Scan project root for clutter:
   - Loose .md files not CLAUDE.md, CLAUDE-local.md, README.md, SESSION-LOCK.md
   - PDFs, images, media not in proper directory
   - Old logs, .bak files, .orig files
   - Orphaned archive directories, stale temp/build artifacts
   - Files that belong in docs/brain/ but ended up at root

2. Scan docs/brain/ for orphaned files:
   - Screenshots older than 2 passes in screenshots/
   - Backup files or duplicates

3. Present findings using template below.
4. Wait for Mark's approval before moving or deleting.
5. Execute approved moves/deletes.
6. Report what was done.

## Output Template

```
=== CLEANUP REPORT ===

MISPLACED: [N] files
  [file] — should move to [destination] (reason)

DELETABLE: [N] files
  [file] — [why it's safe to delete]

CLEAN: [list any areas that look fine]

Proceed with cleanup, or adjust?
=============================
```

## Rules

- NEVER move or delete without Mark's explicit approval.
- NEVER touch CLAUDE.md, CLAUDE-local.md, SESSION-LOCK.md, .gitignore.
- NEVER delete docs/brain/ files — managed by brain system.
- Present full plan. Mark may approve all, some, or none.
- If nothing to clean: "Project root is clean. No action needed."
