<!-- version: 1.1 -->

Emergency context recovery. Fires under context pressure — be fast.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/session/recover.sh --json`
Read JSON: state_written, brain_snapped, uncommitted_files, recommendation.

Present results using the Recovery Dump template from communication.md (pattern 9).

Follow recommendation: "compact" -> try /compact. "clear" -> "Context critical. /clear then /begin."

Selective /compact tip: press Esc+Esc to open the checkpoint picker, select a checkpoint
from before context grew heavy, then /compact. Summarizes from that checkpoint forward
rather than the full context — often recovers more usable space.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."
Write state to STATUS.md. /snap all brain files. Try /compact.
If not enough: "Context critical. /clear then /begin." Stop.

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/recover","status":"complete","emoji":":sos:","summary":"State dumped, snap taken — [compact/clear] recommended","detail_lines":["[uncommitted file count if any]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
