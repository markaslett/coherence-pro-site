<!-- version: 1.0 -->

Full quality loop — runs audit, review, and test until zero issues or round 5 cap.

## Process

Global round counter starts at 0. Cap is 5 total across the entire pipeline.

### Phase 1: Audit (spec compliance)

1. Run /audit (spec mode if docs/planning/*.md exists, change mode otherwise).
2. If MISSING/BROKEN/FAIL findings:
   a. Developer fixes.
   b. Increment round counter.
   c. Re-run /audit. Repeat until clear or round cap.

### Phase 2: Review (iterate mode)

3. Invoke Reviewer subagent (fresh context, full diff).
4. If ANY findings (P0, P1, or P2):
   a. Developer fixes all findings. Zero means zero.
   b. Increment round counter. Check cap.
   c. Clear Reviewer context (mandatory — prevents familiarity bias).
   d. Re-invoke Reviewer as fresh subagent on updated diff.
   e. Repeat until PASS or round cap.

### Phase 3: Independent review (fresh context)

5. Invoke a NEW Reviewer subagent (completely fresh context, full diff).
   This catches anything the iterate-mode reviewer missed due to incremental focus.
6. If ANY findings:
   a. Developer fixes.
   b. Increment round counter. Check cap.
   c. Re-invoke fresh Reviewer. Repeat until PASS or round cap.

### Phase 4: Test

7. Run /test on affected screens (diff-based smart selection).
8. If test failures:
   a. Developer fixes.
   b. Increment round counter. Check cap.
   c. Re-invoke Reviewer (iterate mode) on the fix diff — code changes need review.
   d. Re-run /test. Repeat until both pass or round cap.

### Result

9. All phases clear:
   Report: "Clean: 0 issues after [N] rounds."

10. Round 5 cap hit:
    Report: "Capped at round 5: [remaining issues list]."
    Escalate to Mark for decision.
