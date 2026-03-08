Spec compliance audit. Verify code implements what the planning spec says.
When docs/planning/*.md exists: spec compliance mode.
No specs: fall back to /health (codebase health check).

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /audit."

## Spec Compliance Mode (docs/planning/*.md exists)

All six agents. Four phases. The audit is only as good as the agents running it.

---

### Phase 1 — Requirements Extraction (sequential)

**Specifier** reads every spec in docs/planning/*.md and produces a numbered
list of individually testable requirements. This is the checklist every other
agent works against.

- One requirement = one testable statement.
- Number them: R1, R2, R3...
- Group by spec section but flatten into a single list.
- Ambiguous spec language: Specifier flags it as a Question, does not guess.

Output: numbered requirements list passed to Phase 2 agents.

---

### Phase 2 — Compliance Mapping (parallel)

Three agents run in parallel, each mapping the requirements list to their domain.

**Architect** — Code mapping. For each requirement:
- Find the implementing code location (file:line).
- Assess structural completeness: does code exist for this requirement?
- Set initial status: DONE / PARTIAL / MISSING.
- Architect answers: "Is there code for this?"

**Tester** — Test mapping. For each requirement:
- Find existing tests that cover this requirement (test file:line).
- Flag requirements with no test coverage: UNTESTED.
- Flag requirements with partial coverage (happy path only, no edge cases): UNDERTESTED.
- Tester answers: "Is there a test for this?"

**Documenter** — Documentation mapping. For each requirement:
- Find related help content, glossary entries, user-facing docs, accessibility labels.
- Flag undocumented user-facing features: UNDOCUMENTED.
- Skip internal/non-user-facing requirements.
- Documenter answers: "Is this documented for the user?"

Output: three independent reports merged by Manager into a single table before Phase 3.

---

### Phase 3 — Verification (parallel, DONE/PARTIAL items only)

Two agents run in parallel on items the Architect marked DONE or PARTIAL.
MISSING items skip this phase — nothing to verify.

**Developer(s)** — Data-flow verification. For each DONE/PARTIAL item:
- Trace the actual code path end-to-end. Follow data from input to output.
- A file existing is not enough — the wiring must work.
- Downgrade DONE -> FAIL if the path is broken (value written but never read,
  event fired but nothing subscribes, model saved but view reads elsewhere).
- Downgrade PARTIAL -> BROKEN if the partial path is fundamentally disconnected.
- Developer answers: "Does this actually work end-to-end?"

**Reviewer** — Implementation quality. For each DONE item (after Developer pass):
- Check thread safety, concurrency, error handling at boundaries, race conditions,
  retain cycles, data alignment, edge cases.
- Downgrade DONE -> FAIL if implementation is unsafe or incorrect
  (missing @MainActor on UI mutation, unhandled nil in non-optional path,
  concurrent writes without synchronization).
- Add quality notes even on items that stay DONE.
- Reviewer answers: "Is this safe and correct?"

Downgrades flow forward — agents can only downgrade status, never upgrade.

---

### Phase 4 — Manager Consolidation

Manager merges all six agent reports into a single compliance table.
Resolve conflicts (if Developer says DONE but Reviewer says FAIL, take FAIL).
Apply the worst status for each requirement across all agents.

```
=== SPEC AUDIT — [YYYY-MM-DD] ===

SPECS: [list of files read from docs/planning/]
REQUIREMENTS: N extracted by Specifier

Phase 1: Specifier (requirements) ->
Phase 2: Architect (code) + Tester (tests) + Documenter (docs) ->
Phase 3: Developer (data-flow) + Reviewer (quality) ->
Phase 4: Manager (consolidation)

| # | Requirement | Code Location | Test Location | Status | Flagged By | Test | Docs | Notes |
|---|---|---|---|---|---|---|---|---|
| R1 | Timer shows countdown | Timer/TimerView.swift:45 | Tests/TimerTests.swift:12 | DONE | — | OK | OK | Thread-safe, clean |
| R2 | Haptic on completion | Timer/TimerVM.swift:89 | — | PARTIAL | A | UNTESTED | OK | iPhone only, not Watch |
| R3 | Settings persist | — | — | MISSING | A | UNTESTED | UNDOC | No implementation found |
| R4 | Dark mode support | Settings/SettingsView.swift:20 | Tests/ThemeTests.swift:5 | FAIL | D | OK | OK | View reads hardcoded values, not UserDefaults |
| R5 | Watch complication | Watch/ComplicationView.swift:1 | — | BROKEN | D | UNTESTED | UNDOC | TimelineProvider returns empty entries |
| R6 | Sync engine | Sync/SyncManager.swift:30 | Tests/SyncTests.swift:20 | FAIL | R | UNDERTESTED | OK | Race condition on concurrent sync |

SUMMARY:
  Compliance: DONE: N | PARTIAL: N | MISSING: N | FAIL: N | BROKEN: N
  Testing:    OK: N | UNTESTED: N | UNDERTESTED: N
  Docs:       OK: N | UNDOCUMENTED: N | N/A: N

Flagged By: A = Architect, T = Tester, D = Developer, R = Reviewer, Doc = Documenter
(Shows which agent set the current status or flag. — = no issues found by any agent.)

GATE: [CLEAR / BLOCKED]
  CLEAR = zero MISSING + zero BROKEN + zero FAIL
  BLOCKED = list each blocking item

UNTESTED and UNDOCUMENTED do not block but are surfaced as warnings.
PARTIAL items are noted but do not block.

[If CLEAR]: "Audit clear. Ready for /health."
[If BLOCKED]: "N items must be fixed. Fix and re-run /audit."
=============================
```

---

### Agent Unavailability

If any agent is unavailable, Manager handles that agent's phase solo.
All four phases still run — the work doesn't get skipped, only the delegation.
State which agents were dispatched and which Manager handled in the output header.

## Fallback: Codebase Health Check (no specs)

If docs/planning/ is empty or missing, run /health instead:
codebase health check via Architect. See commands/health.md.

## Rules

- Read-only. /audit never modifies files. All six agents are read-only during audit.
- All six agents, four phases: Specifier -> (Architect + Tester + Documenter) -> (Developer + Reviewer) -> Manager.
- Phases 2 and 3 run their agents in parallel where possible.
- Every requirement extracted by Specifier must appear in the final table. No skipping.
- Code Location and Test Location must be file:line, not just a file name. Use — if none.
- Compliance status definitions:
  - DONE: Fully implemented, data flows end-to-end, implementation is safe.
  - PARTIAL: Partially implemented. Works but incomplete.
  - MISSING: No implementation found. Not started.
  - FAIL: Implementation exists but doesn't work correctly (broken data flow,
    unsafe code, doesn't match spec).
  - BROKEN: Implementation exists but crashes or produces wrong results.
- Test coverage flags: OK, UNTESTED, UNDERTESTED.
- Documentation flags: OK, UNDOCUMENTED, N/A (non-user-facing).
- Downgrades flow forward: Architect sets initial status, Developer and Reviewer
  can only downgrade (DONE->FAIL, PARTIAL->BROKEN), never upgrade.
- UNTESTED and UNDOCUMENTED surface as warnings but do not block the gate.
- /audit is a hard gate: must pass before /health is allowed.
- Workflow: Code -> /audit -> fix -> /audit (repeat) -> /health -> /premerge -> push.
