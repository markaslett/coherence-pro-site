Invoke the Reviewer for an independent code review of the current branch.

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /review."

## Process

1. Determine review scope:
   - Default: current branch diff against develop (or main if no develop)
   - If Mark specifies a branch: review that branch

2. Invoke Reviewer subagent:
   - Reads git diff for all changed files
   - Reads PLAN.md for intent (if present)
   - Reads CONVENTIONS.md, ARCHITECTURE.md, DECISIONS.md
   - Checks every changed file against the full checklist
   - Produces review report with findings by severity

3. Present results to Mark using the AGENT REPORT template.
   Include: verdict (PASS/FAIL), P0 count, P1 count, P2 count.

4. If FAIL: list each blocking item with file:line.
   If PASS WITH NOTES: list P2 suggestions briefly.
   If PASS: confirm clean.

## Rules

- Read-only. Reviewer never modifies files.
- Can be run anytime, not just at /premerge.
- P0 = blocker. P1 = must fix. P2 = suggestion (non-blocking).
- End with: "Fix the findings?" or "Clean — ready to merge?"
