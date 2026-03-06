Daily product owner briefing. Different from /begin — this is strategic
(what happened, what needs attention), not mechanical (lock, validate, sync).

Run /begin first if not already in a session. Then /morning for the briefing.

## Process

1. Read overnight results:
   - docs/brain/TEST-SUMMARY.md (last /test-full results)
   - docs/brain/TESTS.md (recent test history)

2. Read feedback pipeline:
   - docs/brain/feedback/FEEDBACK.md (unprocessed items)
   - Count new items since last session

3. Read session handoff:
   - docs/brain/STATUS.md SESSION HANDOFF section
   - WAITING FOR MARK items
   - DO NOT FORGET items

4. Fetch open issues from GitHub:
   - Count by priority (P0, P1, P2, P3)
   - Any new issues since last session

5. Present daily briefing:

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

FEEDBACK: [N unprocessed items — run /feedback to triage]
  [or: inbox clear]

HANDOFF FROM LAST SESSION:
  [START HERE content from STATUS.md]
  [or: no handoff — clean start]

RECOMMENDED FIRST ACTION:
  [one specific, actionable recommendation with rationale]

=============================
```

## Rules

- Read-only. /morning never modifies files or starts work.
- Always include a recommended first action. Be specific.
- If overnight tests failed: that's the recommendation (fix failures first).
- If feedback is waiting: recommend /feedback before building.
- If nothing urgent: recommend the highest-value open issue.
- Keep it scannable. Mark reads this on his first cup of coffee.
