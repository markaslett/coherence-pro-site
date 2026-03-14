<!-- version: 1.4 -->

Pre-merge gate. Must clear before any merge to develop or main.

## Primary (dev-tools available)

Step 1: Gather data
  `bash ~/projects/claude-dev-tools/gates/premerge-check.sh --json`
  Read JSON: target_branch, merge_conflicts, conflict_files,
  convention_violations, affected_targets, files_changed, ready_for_review,
  pr_summary, commit_audit.

  premerge-check.sh now calls convention-check.sh and pr-summary.sh internally.
  - convention_violations[]: { file, line, rule, message } from convention-check.sh
  - pr_summary: { title, body, commits[], breaking_changes[] } from pr-summary.sh
  - commit_audit: { total, compliant, violations[] } from commit-audit.sh

Step 2: Evaluate blockers
  If merge_conflicts: BLOCK. List conflict_files. "Resolve conflicts first."
  If convention_violations has entries: list each with file:line and rule.

Step 3: Present PR summary to Mark
  Display pr_summary.title and pr_summary.body for review.
  If breaking_changes is non-empty: flag prominently.
  If commit_audit.violations is non-empty: list non-compliant commit messages.
  Mark can edit the summary before it goes on the PR.

Step 4: Load pre-merge hook
  cat ~/projects/claude-dev-kit/modules/hooks/pre-merge.md
  Re-read ARCHITECTURE.md and CONVENTIONS.md for cross-cutting audit.

Step 5: Run /clean
  Runs the full quality loop: audit -> review (iterate) -> independent review -> test.
  See commands/clean.md for the complete pipeline.
  /clean handles all fix-and-recheck cycles with a global round 5 cap.

Step 6: Evaluate full checklist (9 sections from pre-merge.md hook)
  Code review, test results, document audit, cross-cutting impact,
  test coverage, documentation, issue reconciliation, branch hygiene, CLAUDE.md size.

Step 7: Present gate result
  Render via box-table.sh using the template from pre-merge.md Output Format section.
  Pipe structured input through: bash ~/projects/claude-dev-tools/kit/box-table.sh --title "PRE-MERGE GATE — [branch] -> [target]"
  If box-table.sh unavailable, fall back to plain-text template.
  Include PR summary (approved by Mark in Step 3).
  GATE: CLEAR or GATE: BLOCKED with each blocking item listed.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."
Load pre-merge hook: cat ~/projects/claude-dev-kit/modules/hooks/pre-merge.md
Run /clean (quality loop runs without dev-tools dependency).
Manual convention scan via grep/find for print(), missing labels, large files.
Generate PR summary manually from git log and PLAN.md.
Gate must clear before any merge to develop or main.

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/premerge","status":"[clear/blocked]","emoji":"[:white_check_mark:/:no_entry_sign:]","summary":"Gate [CLEAR/BLOCKED] — [N] blockers, [N] convention violations","detail_lines":["[blocking item if any]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
