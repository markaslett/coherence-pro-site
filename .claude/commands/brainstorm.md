<!-- version: 1.1 -->

Design session before significant features, screens, or architecture changes.

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /brainstorm."

## Process

1. Mark states the problem or feature idea.

2. Manager evaluates scope:
   - How many modules affected?
   - Any existing patterns or decisions relevant?
   - What's the risk level?

3. If 3+ modules affected: invoke Architect subagent.
   Architect reads ARCHITECTURE.md, DECISIONS.md, CONVENTIONS.md,
   scans affected code areas, and produces an architecture assessment.
   Present assessment to Mark using the AGENT REPORT template.
   Surface any DECISION REQUESTs from the Architect.

4. Mark makes decisions (if any). Manager records in DECISIONS.md.

5. Invoke Specifier subagent.
   Specifier reads Architect assessment (if produced), ARCHITECTURE.md,
   CONVENTIONS.md, scans Shared/Components/ and feature area.
   Produces PLAN.md with steps, files, verification criteria.
   Present plan summary to Mark using the AGENT REPORT template.

6. Mark approves, adjusts, or rejects the plan.

7. On "go": create feature branch via GitHub MCP, begin BUILD phase.

## Rules

- No code until Mark says "go."
- If task is simpler than expected (<5 files), Specifier says so.
- Architect is only invoked for 3+ module features. Single-module
  features skip straight to Specifier.
- Always use structured output templates from agents.md.
- End with a clear action: "Approve the plan and start building?"

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/brainstorm","status":"complete","emoji":":bulb:","summary":"Design complete — [N] decisions, PLAN.md ready","detail_lines":["Next: [approve plan and start building / pending Mark approval]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
