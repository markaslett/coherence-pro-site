<!-- version: 1.2 -->

Overnight unattended test. All 4 configs, every screen, VoiceOver, zero prompts.

## Primary (dev-tools available)

Step 1: Select test targets
  `bash ~/projects/claude-dev-tools/testing/smart-test-select.sh --json`
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
  `bash ~/projects/claude-dev-tools/testing/test-report.sh --results /tmp/test-results.json --json`
  Script writes TEST-SUMMARY.md and appends to TESTS.md run history (keeps last 10).

Step 5: Voice verification (if audio pipeline active)
  Check CLAUDE-local.md for AUDIO_PIPELINE: true.
  If active, run: `bash ~/projects/claude-dev-tools/audio-pipeline/voice-verify.sh --json`
  Read JSON: result (pass/fail), manifest_entries, code_references,
  missing_in_manifest[], missing_in_code[], orphan_files[], drift_detected.
  Report any manifest/code drift alongside test results.
  If drift_detected: file GitHub issue with P1 label.

Step 6: Present
  If test issues found: file GitHub issues for P0/P1 findings.
  If voice drift found: include in report under VOICE VERIFICATION section.
  Report TEST-SUMMARY.md location and result.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."
Load testing module: cat ~/projects/claude-dev-kit/modules/testing.md
Run /test-full protocol: all 4 configs, every screen, VoiceOver, zero prompts.
Tester writes TEST-SUMMARY.md and TESTS.md directly.
Voice verification: if AUDIO_PIPELINE active, manually check that all speak() calls
have matching entries in the voice manifest file.
