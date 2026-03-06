Fetch all open GitHub issues from the PROJECT repo (detected from
git remote get-url origin, NOT KIT_REPO), read each one
(title + description + labels), group related issues by root cause
or affected area, and present using the TRIAGE REPORT template
from modules/agents.md.

Load the issues module: cat ~/projects/claude-dev-kit/modules/issues.md
Load the agents module: cat ~/projects/claude-dev-kit/modules/agents.md
State "Loaded: issues.md + agents.md — running /triage."

Fetch all open issues from PROJECT repo via GitHub MCP. For each issue, read:
- Title
- Description/body
- Labels (priority, type)
- Affected files (if mentioned)

Group issues that share:
- Same root cause (e.g., multiple symptoms of one bug)
- Same screen or feature area
- Same component (e.g., all Shared/Components/ issues)
- Same category (e.g., all accessibility issues)

Output using the TRIAGE REPORT template (Section: Manager-to-Mark
Output Templates, Template 5 in modules/agents.md):
- Each group gets a complexity rating (SIMPLE/MEDIUM/COMPLEX)
- Plain English descriptions only — no GitHub label jargon
- SUGGESTED ORDER with reasoning
- End with "Which group to fix, or discuss priorities?"

When Mark says "fix Group N", the Manager evaluates the batch complexity
and runs the appropriate crew:
- Small group (1-3 files): Manager handles solo
- Medium group (4-10 files): Specifier -> Developer -> Tester -> Reviewer
- Large group (10+ files): Full crew with Architect

Each group becomes a single feature branch: fix/[area-name].
