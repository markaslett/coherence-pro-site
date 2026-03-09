Work hub for examining, diagnosing, and fixing GitHub issues.

## Primary (dev-tools available)

Run: `bash ~/projects/dev-tools/issues/list.sh --sync --json`
Read JSON: counts (p0-p3, questions, test_failures, deferred), total_open,
last_issue, issues array.

Present results using the Issue List template from communication.md (pattern 6).

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."
Load issues module: cat ~/projects/claude-dev-kit/modules/issues.md
Show issue menu: P0 through Deferred, counts per category.
