<!-- version: 1.1 -->

Show session recap. Features added, issues closed, decisions made,
commits, reconciliation check. Also runs as first step of /save.

When /save includes a merge to develop or main, present the merge portion
using the Merge Summary template from communication.md (pattern 10).

For non-merge sessions, use the standard recap format:
FEATURES, ISSUES CLOSED, DECISIONS, COMMITS, FILES CHANGED, TESTS,
AGENTS USED, STILL OPEN, RECONCILIATION.

[!] in reconciliation requires "save anyway" before /save proceeds.

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/summary","status":"complete","emoji":":memo:","summary":"[N] features, [N] issues closed, reconciliation [OK/!]","detail_lines":[],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
