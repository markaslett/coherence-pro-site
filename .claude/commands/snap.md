<!-- version: 1.0 -->

Mid-session save. Update brain files for changed files, no commit.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/session/checkpoint.sh --json`
(No --commit flag — updates brain file frontmatter timestamps only.)
Read JSON: brain_files_updated list.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."
Scope to changed files. Update brain files touched by session diff.
Skip screenshots if no View files in git diff. No commit.
Auto-snap: after feature/fix, before /test, before branch switch.

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/snap","status":"complete","emoji":":camera:","summary":"Brain files updated — [N] files refreshed","detail_lines":[],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
