Smart diff-based test. Maps changed files to affected screens via TEST-MAP.md.
Tests on 16-L + 17PM-L, light + dark. Stops on P0 or P1.

## Primary (dev-tools available)

Run: `bash ~/projects/dev-tools/testing/smart-test-select.sh --json`
Read JSON: changed_files, affected_screens, unit_tests, confidence.

If confidence == "low" or affected_screens empty: warn, suggest /test-full.

Load testing module: cat ~/projects/claude-dev-kit/modules/testing.md
Pass affected_screens to testing protocol. Test on 16-L + 17PM-L.

### /test [screen] — Targeted Single Screen

When a screen name is provided (e.g., `/test Settings`):
Skip smart-test-select.sh. Test the named screen on all 4 configs
(16-L, 16-D, 17PM-L, 17PM-D). Report per-config results.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."
Load testing module: cat ~/projects/claude-dev-kit/modules/testing.md
Run /test protocol: read git diff, map via TEST-MAP.md, test affected screens on 16-L + 17PM-L.
