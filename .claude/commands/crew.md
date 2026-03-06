Show agent roster status and allow manual invocation of any role.

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /crew."

Check AGENTS key in CLAUDE-local.md. Default: all active.

Display roster:

```
=== CREW — Agent Roster ===
AGENTS: [all / list / none]

| Role | Status | Model | Last Used |
|------|--------|-------|-----------|
| Architect | [active/disabled/missing] | Opus | [date or never] |
| Specifier | [active/disabled/missing] | Sonnet | [date or never] |
| Developer | [active/disabled/missing] | Sonnet | [date or never] |
| Tester | [active/disabled/missing] | Sonnet | [date or never] |
| Reviewer | [active/disabled/missing] | Opus | [date or never] |
| Documenter | [active/disabled/missing] | Sonnet | [date or never] |

COMMANDS:
  "Run [role]" — invoke a specific agent
  "Solo" — disable all agents for this session
  "Full crew" — force full crew for next task
=============================
```

Status logic:
- active: .claude/agents/[role].md exists AND not in AGENTS: none
- disabled: AGENTS key excludes this role
- missing: .claude/agents/[role].md file not found

If Mark says "Run [role]", invoke that agent immediately with
the current task context.
