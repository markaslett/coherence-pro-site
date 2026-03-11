<!-- version: 1.2 -->

Invoke the Reviewer for an independent code review of the current branch.
Default: iterate mode (review -> fix -> re-review until clean).
Use --single for one-pass-only when Mark wants manual control.

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /review."

## Process (iterate mode — default)

1. Determine review scope:
   - Default: current branch diff against develop (or main if no develop)
   - If Mark specifies a branch: review that branch

2. Invoke Reviewer subagent (fresh context):
   - Reads git diff for all changed files
   - Reads PLAN.md for intent (if present)
   - Reads CONVENTIONS.md, ARCHITECTURE.md, DECISIONS.md
   - Checks every changed file against the full checklist
   - Produces review report with findings by severity

3. Present results to Mark using the AGENT REPORT template.
   Include: verdict (PASS/FAIL), P0 count, P1 count, P2 count.

4. If PASS (0 P0, 0 P1, 0 P2): "Clean — ready to merge."
   If ANY findings (P0, P1, or P2):
   a. Dispatch Developer to fix all findings. Zero means zero.
   b. /clear Reviewer context (mandatory — prevents familiarity bias).
   c. Re-invoke Reviewer as fresh subagent on the updated diff.
   d. Repeat until PASS or round 5 hard cap.

5. Round 5 cap: if still not clean after 5 rounds, escalate:
   "Review loop hit 5 rounds without clean pass. Issues remaining: [list].
   Mark: intervene or approve with notes?"

## Process (--single mode)

Steps 1-3 only. Present results. End with:
"Fix the findings?" or "Clean — ready to merge?"
No automatic fix-and-re-review loop.

## Rules

- Read-only. Reviewer never modifies files.
- Can be run anytime, not just at /premerge.
- P0 = blocker. P1 = must fix. P2 = suggestion.
- ALL findings trigger another round. Zero means zero.
- Round 2+ MUST use fresh Reviewer context (/clear before re-invoke).
- /premerge always uses iterate mode.
