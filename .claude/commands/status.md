<!-- version: 1.1 -->

Show live project status. Phase, branch, issues, feedback, stack, recommendation.
Use compact format on LIMITED/MOBILE interfaces.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/session/status.sh --json`
(Use --compact for LIMITED/MOBILE interfaces.)

Read JSON output. Present using /status format from CLAUDE.md:
FULL: PROJECT, REPO, PHASE, BRANCH, INTERFACE, CREW, NEEDS ATTENTION, ISSUES,
FEEDBACK, TESTS, LAST SESSION, ACTIVE PLAN, STACK, KIT, RECOMMENDED.
COMPACT: Project | phase | branch | crew | critical | issues | next.

One recommendation. Specific, not generic.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."
Read: STATUS.md, ISSUES.md, TESTS.md, PLAN.md, FEEDBACK.md, CLAUDE.md version.
Git: status, branch, log -5, commits behind.
Shell: Never $() inside Bash. Run separately, capture, pass as literals.
Use compact format on LIMITED/MOBILE.

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/status","status":"complete","emoji":":bar_chart:","summary":"Phase [N] — [branch] — P0:[N] P1:[N] P2:[N]","detail_lines":["[recommendation line]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
