<!-- version: 1.0 -->

Pull TestFlight feedback into FEEDBACK.md for processing.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/testflight-sync/sync-testflight-feedback.sh --dry-run`
Review dry-run output. If new feedback found:
Run: `bash ~/projects/claude-dev-tools/testflight-sync/sync-testflight-feedback.sh`
Report new items pulled.
Suggest: "Run /feedback to process into GitHub issues."

## Fallback (dev-tools missing)

If TESTFLIGHT_SYNC_SCRIPT is set in CLAUDE-local.md: run that script instead.
If TESTFLIGHT_SYNC_SCRIPT not defined: "TestFlight sync not configured.
Set TESTFLIGHT_SYNC_SCRIPT in CLAUDE-local.md or install dev-tools."
