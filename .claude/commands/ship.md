Pre-TestFlight shipping workflow. Bumps build number, generates tester
summary, gets Mark's approval, commits. Pairs with /testflight (which
pulls feedback IN — /ship pushes builds OUT).

## Step 1: Pre-flight checks

Run these checks. Report each as [OK] or [FAIL]. Any FAIL = hard block
(except tests, which Mark can override).

1. Branch clean: `git status --porcelain` is empty.
2. No P0 issues: `gh issue list --label P0 --state open` returns nothing.
   P0 open = HARD BLOCK. Cannot override.
3. Build succeeds: use XcodeBuildMCP or `xcodebuild build` on the current
   scheme. If no Xcode project, skip this check with [SKIP].
4. Tests pass: use XcodeBuildMCP or `xcodebuild test`. If no test target,
   [SKIP]. If tests fail, report and ask: "Ship with failing tests? (yes/no)"

If any hard block: stop. Print what failed. Do not proceed.

## Step 2: Read current build number

### Primary (dev-tools available)
Run: `bash ~/projects/dev-tools/kit/build-bump.sh --check --json`
Read JSON: old_build, new_build (preview only — not bumped yet).
Read marketing version: `agvtool what-marketing-version -terse1`
If that fails: `grep -r 'MARKETING_VERSION' *.xcodeproj/project.pbxproj | head -1`
Store: CURRENT_BUILD = old_build, NEW_BUILD = new_build, VERSION.

### Fallback
Run: `agvtool what-version -terse` to get current build number.
If agvtool not configured: `grep -r 'CURRENT_PROJECT_VERSION' *.xcodeproj/project.pbxproj | head -1`
Store: CURRENT_BUILD, NEW_BUILD = CURRENT_BUILD + 1.
Read marketing version: `agvtool what-marketing-version -terse1`
If that fails: `grep -r 'MARKETING_VERSION' *.xcodeproj/project.pbxproj | head -1`
Store: VERSION.

## Step 3: Bump build number

### Primary (dev-tools available)
Run: `bash ~/projects/dev-tools/kit/build-bump.sh --json`
Read JSON: old_build, new_build, bumped. Verify bumped == true.

### Fallback
Run: `agvtool new-version -all $NEW_BUILD`
If agvtool not configured: update CURRENT_PROJECT_VERSION in project.pbxproj directly.
Verify: `agvtool what-version -terse` returns NEW_BUILD.

## Step 4: Generate "What to Test" summary

Find the last TestFlight tag: `git tag -l 'testflight/*' --sort=-version:refname | head -1`
If no previous tag: use the last 20 commits as the range.

Gather from the range (last tag to HEAD):
- Closed issues: `gh issue list --state closed --search "closed:>LAST_TAG_DATE" --json number,title`
- Merged PRs: `gh pr list --state merged --search "merged:>LAST_TAG_DATE" --json number,title`
- Commits: `git log LAST_TAG..HEAD --oneline`
- Open P1/P2: `gh issue list --state open --label P1,P2 --json number,title`
- Active PLAN.md: read if exists, note completed items.

Rewrite each item in plain English for testers (not developers).
"Fixed crash when..." not "fix(repo): nil guard on optional chain".

## Step 5: Present for approval

```
=== SHIP — TestFlight Build ===

BUILD: v{VERSION} (build {NEW_BUILD})  ← was build {CURRENT_BUILD}
BRANCH: {current branch}

WHAT'S NEW (for testers):
  - {plain English description of each change}
  - {one line per item}

KNOWN ISSUES:
  - {open P1/P2, if any}
  {or: None}

PRE-FLIGHT:
  {[OK/FAIL/SKIP] for each check from Step 1}

Approve, edit, or cancel?
=============================
```

Wait for response:
- **approve / go / yes**: proceed to Step 6.
- **edit**: Mark provides modified summary. Re-present with edits. Wait again.
- **cancel**: revert build number bump (`agvtool new-version -all $CURRENT_BUILD`), stop.

## Step 6: Commit, tag, push

1. Stage only build number changes:
   `git add *.xcodeproj/project.pbxproj` (or whatever agvtool modified)
2. Commit:
   ```
   chore: bump build to {NEW_BUILD} for TestFlight

   v{VERSION} build {NEW_BUILD}
   ```
3. Tag: `git tag testflight/v{VERSION}-b{NEW_BUILD}`
4. Push: `git push && git push --tags`
5. Print:
   ```
   Shipped: v{VERSION} build {NEW_BUILD}
   Tag: testflight/v{VERSION}-b{NEW_BUILD}
   Ready for TestFlight upload: Xcode > Product > Archive
   ```

## Rules

- NEVER upload to TestFlight automatically. Mark does that in Xcode.
- NEVER ship with P0 issues open. Hard block. No override.
- P1/P2 can ship if Mark explicitly approves — list them under KNOWN ISSUES.
- Build number is the only file modified. No code changes during /ship.
- If no closed issues or PRs found: ask Mark to describe what changed.
- Tag format: testflight/v{VERSION}-b{BUILD} for easy history.
- On cancel: always revert the build number bump. Leave no trace.
