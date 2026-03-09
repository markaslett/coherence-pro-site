Invoke the Architect in audit mode for a full codebase health check.
Different from /review (checks a branch diff) — /health checks the entire codebase.
Different from /audit (checks spec compliance) — /health checks code quality.

## Primary (dev-tools available)

Step 1: Gather findings
  `bash ~/projects/dev-tools/scanning/health-scan.sh --json`
  `bash ~/projects/dev-tools/scanning/proactive-scan.sh --json`
  Read JSON from both scripts. Merge findings into a single structured report.

Step 2: Invoke Architect subagent
  Load agents module: cat ~/projects/claude-dev-kit/modules/agents.md
  State "Loaded: agents.md — running /health."
  Pass merged findings to Architect as structured input.
  Architect interprets findings, checks cross-cutting concerns, produces report.

Step 3: Present results using the AGENT REPORT template (same as current output).

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /health."

Invoke Architect subagent with audit instructions:
- Scan the entire codebase, not just a diff
- Read CONVENTIONS.md, ARCHITECTURE.md, DECISIONS.md for context
- Check every scan target below

Scan targets:
- Dead code: functions/types never referenced
- Unreferenced files: .swift files not imported or used
- Unused imports: import statements for unused modules
- Obsolete schema entries: SwiftData models with stale fields
- Old test code: tests for features that no longer exist
- Files over 250 lines: candidates for splitting
- Duplicated logic: similar code in multiple places
- Convention violations: patterns that contradict CONVENTIONS.md
- Missing accessibility labels on interactive elements
- print() statements in production code (should be Logger)
- Hardcoded strings that should be in String Catalog
- Hex colors in Swift that should be in asset catalog

Present results using the AGENT REPORT template:

```
=== ARCHITECT REPORT (HEALTH CHECK) ===
Agent: Architect
Task: Full codebase health audit

RESULT: [HEALTHY / NEEDS ATTENTION / UNHEALTHY]

FINDINGS BY CATEGORY:
  [P0] Critical — [count]
    - [finding with file:line]

  [P1] Important — [count]
    - [finding with file:line]

  [P2] Suggestion — [count]
    - [finding summary, detail on request]

TOP 3 RECOMMENDATIONS:
  1. [most impactful fix — what and why]
  2. [second most impactful]
  3. [third most impactful]

Fix the findings, or discuss priorities?
=============================
```

## Rules

- Read-only. /health never modifies files.
- Architect subagent runs the scan. If unavailable, Manager handles solo.
- P0 = blocking. P1 = should fix. P2 = suggestion.
- Group findings by category, not by file.
- End with actionable next step.
- If codebase is clean: "HEALTHY — no significant findings."
