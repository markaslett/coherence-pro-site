Overnight unattended test. All 4 configs, every screen, VoiceOver, zero prompts.

## Primary (dev-tools available)

Step 1: Select test targets
  `bash ~/projects/dev-tools/testing/smart-test-select.sh --json`
  Read JSON: changed_files, affected_screens, unit_tests, confidence.
  If confidence == "low" or affected_screens empty: test ALL screens.

Step 2: Load testing module
  cat ~/projects/claude-dev-kit/modules/testing.md
  State "Loaded: testing.md — running /test-full."

Step 3: Invoke Tester subagent
  Pass affected_screens (or "all") and unit_tests to Tester.
  All 4 configs (16-L, 16-D, 17PM-L, 17PM-D).
  VoiceOver audit. Dynamic Type check. Zero prompts — fully unattended.

Step 4: Format results
  Tester produces raw results. Then:
  `bash ~/projects/dev-tools/testing/test-report.sh --results /tmp/test-results.json --json`
  Script writes TEST-SUMMARY.md and appends to TESTS.md run history (keeps last 10).

Step 5: Present
  If issues found: file GitHub issues for P0/P1 findings.
  Report TEST-SUMMARY.md location and result.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."
Load testing module: cat ~/projects/claude-dev-kit/modules/testing.md
Run /test-full protocol: all 4 configs, every screen, VoiceOver, zero prompts.
Tester writes TEST-SUMMARY.md and TESTS.md directly.
