<!-- version: 1.0 -->

Batch view of open issues grouped by root cause. Recommends fix order.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/issues/triage.sh --json`
Read JSON: groups (root_cause, issues, recommended_order, fix_estimate),
ungrouped, recommended_first.

Present results using the Triage Report template from communication.md (pattern 5).

When Mark says "fix Group N": evaluate batch complexity, create branch fix/[area],
run appropriate crew (1-3 files: solo, 4-10: Specifier->Developer->Tester->Reviewer,
10+: full crew with Architect).

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."

Load the issues module: cat ~/projects/claude-dev-kit/modules/issues.md
Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: issues.md + agents.md — running /triage."

Fetch all open issues from PROJECT repo via GitHub MCP. For each issue, read:
- Title, Description/body, Labels (priority, type), Affected files (if mentioned)

Group issues that share:
- Same root cause, same screen/feature area, same component, same category

Present using the Triage Report template from communication.md (pattern 5).
Each group gets complexity rating (SIMPLE/MEDIUM/COMPLEX).
SUGGESTED ORDER with reasoning.
End with "Which group to fix, or discuss priorities?"

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/triage","status":"complete","emoji":":bar_chart:","summary":"[N] issues triaged — [N] groups, recommended first: [issue]","detail_lines":[],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
