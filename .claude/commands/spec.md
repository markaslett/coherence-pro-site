<!-- version: 1.1 -->

Invoke the Specifier to produce a PLAN.md for the current task.

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /spec."

## Process

1. Read Mark's feature description or task.

2. If an Architect assessment exists from a prior /brainstorm or
   /research, include it as context.

3. Invoke Specifier subagent:
   - Reads ARCHITECTURE.md, CONVENTIONS.md, DECISIONS.md
   - Scans Shared/Components/ for reuse opportunities
   - Scans the feature area in the codebase
   - Produces docs/brain/PLAN.md with:
     Goal, design decisions, implementation steps (each mapped to
     exact file path), files table, reuse, verification criteria, risks

4. Present plan summary to Mark using the AGENT REPORT template.
   Include: estimated file count, key steps, any decisions needed.

5. Wait for Mark's approval before any code.

## Rules

- No code. Plan only.
- If the task is simpler than expected (<5 files), Specifier says so
  and Manager can handle solo.
- On approval: create feature branch, begin BUILD phase.
- End with: "Approve the plan and start building?"

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/spec","status":"complete","emoji":":triangular_ruler:","summary":"PLAN.md written — [N] files estimated, [SIMPLE/MEDIUM/COMPLEX]","detail_lines":["[key design decision or risk if any]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
