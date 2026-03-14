<!-- version: 1.0 -->

Work hub for examining, diagnosing, and fixing GitHub issues.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/issues/list.sh --sync --json`
Read JSON: counts (p0-p3, questions, test_failures, deferred), total_open,
last_issue, issues array.

Present results using the Issue List template from communication.md (pattern 6).

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."
Load issues module: cat ~/projects/claude-dev-kit/modules/issues.md
Show issue menu: P0 through Deferred, counts per category.

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/issues","status":"complete","emoji":":clipboard:","summary":"[N] open issues — P0:[N] P1:[N] P2:[N]","detail_lines":[],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
