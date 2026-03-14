<!-- version: 1.1 -->

Invoke the Documenter to update brain files.

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /docs."

## Process

1. Invoke Documenter subagent:
   - Reads git diff and recent commit log
   - Reads all brain files in docs/brain/
   - Compares brain file content against actual codebase
   - Updates only what's stale or missing
   - Sets updated_by: documenter in frontmatter

2. Present results to Mark using the AGENT REPORT template.
   Include: which files updated, what changed, any discrepancies found.

## Rules

- Documenter writes only to docs/brain/. Never modifies source code.
- Never modifies DECISIONS.md (written at decision time, not retroactively).
- Never creates new brain files without explicit request.
- Minimum changes — update what's stale, leave the rest.
- End with: "Brain files current." or "N discrepancies found — see STATUS.md."

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/docs","status":"complete","emoji":":books:","summary":"Brain files updated — [N] files changed","detail_lines":["[list of updated brain files]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
