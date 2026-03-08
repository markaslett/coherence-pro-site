Quick targeted test. Run only tests matching files changed since last commit.
Faster than /test (no simulator UI checks) and /test-full (no full matrix).
Unit tests only, mapped by convention.

## Process

1. Get changed files:
   ```
   git diff --name-only HEAD
   ```
   If no changes (clean tree), use HEAD~1 instead.

2. Filter to .swift source files. Exclude test files, previews, and non-code files.

3. Map each source file to its test file by convention:
   - `FooService.swift` → `FooServiceTests.swift`
   - `FooViewModel.swift` → `FooViewModelTests.swift`
   - `FooView.swift` → `FooViewTests.swift`
   - Search the test target directories for matches.

4. If matching test files found:
   - Build the test target.
   - Run only matching tests via xcodebuild:
     ```
     xcodebuild test -scheme [scheme] -destination 'platform=iOS Simulator,name=iPhone 16' \
       -only-testing:[TestTarget]/[TestClass] ...
     ```
   - Report pass/fail per test file.

5. If NO matching test files found:
   "No test files match the changed sources: [list files].
   Run /test for UI checks or /test-full for the full suite."

## Output

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
- Does not replace /test, /test-full, or /audit. This is for fast feedback during development.
- If xcodebuild fails to build the test target, report the build error and stop.
- On FAIL: show the failing test name and assertion message.
