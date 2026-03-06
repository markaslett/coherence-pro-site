Scan project root for misplaced files and propose reorganization.
Mark approves before anything moves.

## Process

1. Scan project root for clutter:
   - Loose .md files that aren't CLAUDE.md, CLAUDE-local.md, README.md, or SESSION-LOCK.md
   - PDFs, images, or media files not in a proper directory
   - Old logs, .bak files, .orig files
   - Orphaned archive directories
   - Stale temp files or build artifacts
   - Files that belong in docs/brain/ but ended up at root

2. Scan docs/brain/ for orphaned files:
   - Screenshots older than 2 passes in screenshots/
   - Backup files or duplicates

3. Present findings using this template:

```
=== CLEANUP REPORT ===

MISPLACED: [N] files
  [file] — should move to [destination] (reason)
  [file] — should move to [destination] (reason)

DELETABLE: [N] files
  [file] — [why it's safe to delete]
  [file] — [why it's safe to delete]

CLEAN: [list any areas that look fine]

Proceed with cleanup, or adjust?
=============================
```

4. Wait for Mark's approval before moving or deleting anything.
5. Execute approved moves/deletes.
6. Report what was done.

## Rules

- NEVER move or delete without Mark's explicit approval.
- NEVER touch CLAUDE.md, CLAUDE-local.md, SESSION-LOCK.md, .gitignore.
- NEVER delete docs/brain/ files — those are managed by the brain system.
- Present the full plan. Mark may approve all, some, or none.
- If nothing to clean: "Project root is clean. No action needed."
