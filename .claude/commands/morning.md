<!-- version: 1.1 -->

Daily product owner briefing. Different from /begin — this is strategic
(what happened, what needs attention), not mechanical (lock, validate, sync).

Run /begin first if not already in a session. Then /morning for the briefing.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/session/morning.sh --json`
Read JSON: overnight_tests, new_feedback, issues_changed, last_session, recommended_priority.

Present results using the Morning Briefing template from communication.md (pattern 7).

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."

1. Read overnight results:
   - docs/brain/TEST-SUMMARY.md (last /test-full results)
   - docs/brain/TESTS.md (recent test history)

2. Read feedback pipeline:
   - docs/brain/input/INPUT.md (unprocessed items)
   - Count new items since last session

3. Read session handoff:
   - docs/brain/STATUS.md SESSION HANDOFF section
   - WAITING FOR MARK items
   - DO NOT FORGET items

4. Fetch open issues from GitHub:
   - Count by priority (P0, P1, P2, P3)
   - Any new issues since last session

5. Present daily briefing using the Morning Briefing template from communication.md (pattern 7).

## Output Template

```
=== MORNING BRIEFING — [YYYY-MM-DD] ===

OVERNIGHT:
  Tests: [all pass / N failures — details]
  TestFlight: [N new feedback items / no new feedback / not configured]

NEEDS YOUR INPUT:
  - [decisions waiting, questions pending]
  [or: nothing waiting]

OPEN WORK:
  P0: [count]  P1: [count]  P2: [count]  P3: [count]
  New since last session: [list or "none"]

INPUT: [N unprocessed items — run /input to triage]
  [or: inbox clear]

HANDOFF FROM LAST SESSION:
  [START HERE content from STATUS.md]
  [or: no handoff — clean start]

RECOMMENDED FIRST ACTION:
  [one specific, actionable recommendation with rationale]

=============================
```

## Rules

- Report debt trend from METRICS.md (docs/brain/METRICS.md) if the file exists.
  Include in OPEN WORK section: "Debt: [N] points ([+/-M] from last session)."
- Read-only. /morning never modifies files or starts work.
- Always include a recommended first action. Be specific.
- If overnight tests failed: that's the recommendation (fix failures first).
- If feedback is waiting: recommend /input before building.
- If nothing urgent: recommend the highest-value open issue.
- Keep it scannable. Mark reads this on his first cup of coffee.

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/morning","status":"complete","emoji":":sunrise:","summary":"[N] overnight results, [N] feedback items, [N] P0 issues","detail_lines":["Recommended: [first action]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
