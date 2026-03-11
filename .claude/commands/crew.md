<!-- version: 1.0 -->

Show agent roster status and allow manual invocation of any role.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/session/crew.sh --json`
Read JSON: agents array (name, deployed, last_used), total, deployed, missing.

Present results using the Crew Status template from communication.md (pattern 8).

If Mark says "Run [role]", invoke that agent immediately with current task context.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."

Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: agents.md — running /crew."

Check AGENTS key in CLAUDE-local.md. Default: all active.

Display roster using the Crew Status template from communication.md (pattern 8).

Status logic:
- active: .claude/agents/[role].md exists AND not in AGENTS: none
- disabled: AGENTS key excludes this role
- missing: .claude/agents/[role].md file not found

If Mark says "Run [role]", invoke that agent immediately with current task context.
