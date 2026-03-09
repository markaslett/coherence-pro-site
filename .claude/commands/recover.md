Emergency context recovery. Fires under context pressure — be fast.

## Primary (dev-tools available)

Run: `bash ~/projects/dev-tools/session/recover.sh --json`
Read JSON: state_written, brain_snapped, uncommitted_files, recommendation.

Present results using the Recovery Dump template from communication.md (pattern 9).

Follow recommendation: "compact" -> try /compact. "clear" -> "Context critical. /clear then /begin."

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."
Write state to STATUS.md. /snap all brain files. Try /compact.
If not enough: "Context critical. /clear then /begin." Stop.
