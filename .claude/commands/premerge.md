Pre-merge gate. Must clear before any merge to develop or main.

## Primary (dev-tools available)

Step 1: Gather data
  `bash ~/projects/dev-tools/gates/premerge-check.sh --json`
  Read JSON: target_branch, merge_conflicts, conflict_files,
  convention_violations, affected_targets, files_changed, ready_for_review.

Step 2: Evaluate blockers
  If merge_conflicts: BLOCK. List conflict_files. "Resolve conflicts first."
  If convention_violations has entries: list each with file:line.

Step 3: Load pre-merge hook
  cat ~/projects/claude-dev-kit/modules/hooks/pre-merge.md
  Re-read ARCHITECTURE.md and CONVENTIONS.md for cross-cutting audit.

Step 4: Invoke Reviewer subagent
  Pass branch diff + affected_targets.screens from script output.
  Reviewer produces review report (P0/P1/P2).

Step 5: Invoke Tester subagent
  Pass affected_targets.screens and affected_targets.unit_tests from script.
  Tester runs all 4 configs on affected screens. Produces TEST-SUMMARY.md.

Step 6: Evaluate full checklist (9 sections from pre-merge.md hook)
  Code review, test results, document audit, cross-cutting impact,
  test coverage, documentation, issue reconciliation, branch hygiene, CLAUDE.md size.

Step 7: Present gate result
  Use PRE-MERGE GATE output template from pre-merge.md.
  GATE: CLEAR or GATE: BLOCKED with each blocking item listed.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."
Load pre-merge hook: cat ~/projects/claude-dev-kit/modules/hooks/pre-merge.md
Run the full checklist. Invoke Reviewer + Tester agents.
Manual convention scan via grep/find for print(), missing labels, large files.
Gate must clear before any merge to develop or main.
