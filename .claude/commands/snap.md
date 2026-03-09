Mid-session save. Update brain files for changed files, no commit.

## Primary (dev-tools available)

Run: `bash ~/projects/dev-tools/session/checkpoint.sh --json`
(No --commit flag — updates brain file frontmatter timestamps only.)
Read JSON: brain_files_updated list.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."
Scope to changed files. Update brain files touched by session diff.
Skip screenshots if no View files in git diff. No commit.
Auto-snap: after feature/fix, before /test, before branch switch.
