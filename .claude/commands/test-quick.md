<!-- version: 1.1 -->

Quick targeted test. Run only tests matching files changed since last commit.
Faster than /test (no simulator UI checks) and /test-full (no full matrix).
Unit tests only, mapped by convention.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/testing/smart-test-select.sh --since-commit --json`
Read JSON: changed_files, affected_screens, unit_tests, confidence.

If unit_tests is empty: "No test files match the changed sources. Run /test for UI checks or /test-full for the full suite."

If unit_tests has entries: build and run via xcodebuild:
  `xcodebuild test -scheme [scheme] -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:[target] ...`

Report using the output template below.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."

1. Get changed files: `git diff --name-only HEAD` (clean tree: use HEAD~1).
2. Filter to .swift source files. Exclude test files, previews, non-code.
3. Map each source to test by convention:
   - FooService.swift → FooServiceTests.swift
   - FooViewModel.swift → FooViewModelTests.swift
   - FooView.swift → FooViewTests.swift
4. Build test target, run only matching tests via xcodebuild -only-testing.
5. If no matches: "No test files match. Run /test or /test-full."

## Output Template

```
=== TEST-QUICK — [YYYY-MM-DD] ===
CHANGED: [N] source files
MATCHED: [N] test files
  - FooServiceTests: PASS (0.3s)
  - BarViewModelTests: PASS (0.1s)
  - BazRepositoryTests: FAIL — testFetchReturnsEmpty (expected 3, got 0)
RESULT: [ALL PASS / N FAILURES]
================================
```

## Rules

- Never runs simulators for UI testing. Unit tests only.
- Does not replace /test, /test-full, or /audit. For fast feedback during development.
- If xcodebuild fails to build: report build error and stop.
- On FAIL: show failing test name and assertion message.
