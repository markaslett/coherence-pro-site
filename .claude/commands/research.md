<!-- version: 1.1 -->

Invoke the Architect in investigation mode. No plan, no spec — just
informed analysis on a topic Mark wants to understand.

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /research."

## Process

1. Read Mark's research topic.

2. Invoke Architect subagent with investigation instructions:
   - Read ARCHITECTURE.md for current structure
   - Read DECISIONS.md for prior art and past choices
   - Scan codebase for relevant existing implementations
   - Use Xcode MCP / built-in knowledge for Apple framework docs
   - Research the topic thoroughly

3. Architect produces a structured research report to stdout.

4. Manager presents findings using this format:

```
=== RESEARCH — [topic] ===

CONTEXT:
  [Why this matters. What Mark is trying to solve. 2-3 sentences.]

FINDINGS:
  - [Key finding 1 — what we learned]
  - [Key finding 2 — what we learned]
  - [Key finding 3 — what we learned]

PRIOR ART:
  [What already exists in the codebase or DECISIONS.md that's relevant.
   "None" if this is entirely new territory.]

OPTIONS:

  OPTION A: [name]
    How: [approach in 2-3 sentences]
    Pros: [list]
    Cons: [list]
    Effort: [estimated file count and complexity]

  OPTION B: [name]
    How: [approach]
    Pros: [list]
    Cons: [list]
    Effort: [estimate]

  [OPTION C: (only if genuinely different)]

RECOMMEND: [A/B/C] — [why, 1-2 sentences]

RISKS:
  - [what could go wrong or needs more investigation]

Want to go deeper on any option, or ready to /brainstorm a plan?
=============================
```

## Rules

- Research only. No code. No file modifications.
- Architect uses read-only tools.
- Always check DECISIONS.md — don't recommend something already rejected.
- If the topic is simple enough to answer without the Architect,
  Manager answers directly. No subagent overhead for "what's NSUserDefaults."
- End with clear next action: deeper research, /brainstorm, or just proceed.
