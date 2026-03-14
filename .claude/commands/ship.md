<!-- version: 1.2 -->

Pre-TestFlight shipping workflow. Bumps build number, generates tester
summary, gets Mark's approval, commits. Pairs with /testflight (which
pulls feedback IN — /ship pushes builds OUT).

## Step 1: Pre-flight checks

### Primary (dev-tools available)
Run: `bash ~/projects/claude-dev-tools/kit/testflight-preflight.sh --json`
Read JSON: result (go/no_go), gates[]: { name, status, details }.

testflight-preflight.sh orchestrates 8 gates:
- build-bump.sh --check: current/next build number, marketing version
- issues/list.sh --label P0,P1: open blockers
- voice-verify.sh: manifest/code drift (if AUDIO_PIPELINE active)
- proactive-scan.sh --deep: large files, print(), stale TODOs, debug logging
- convention-check.sh: code style violations
- git status: clean tree check
- xcodebuild build: build verification
- xcodebuild test: test pass/fail

Present each gate as [GO] or [NO-GO] with details.
P0 open = HARD BLOCK. Cannot override.
Other NO-GO items: Mark can override with "ship anyway".

### Fallback
Run manual checks:
1. Branch clean: `git status --porcelain` is empty.
2. No P0 issues: `gh issue list --label P0 --state open` returns nothing.
3. Build succeeds: use XcodeBuildMCP or `xcodebuild build`.
4. Tests pass: use XcodeBuildMCP or `xcodebuild test`.
Report each as [OK] or [FAIL]. Any FAIL = hard block (except tests, Mark can override).

## Step 1b: Physical device checklist

Present this checklist to Mark. Each item is manual — Claude cannot verify these.
Mark confirms each as [OK], [SKIP], or [FAIL]. Any FAIL = block (Mark can override).

```
PHYSICAL DEVICE CHECKLIST:
  [ ] App launches on physical iPhone (< 2s)
  [ ] App launches on physical Apple Watch
  [ ] Watch HR streaming works during live session
  [ ] Haptics fire correctly on Watch
  [ ] Bluetooth pairing/reconnection works
  [ ] Display-off → resume works on Watch
  [ ] Schema migration on real data (not empty install)
  [ ] End-to-end flow: install → pair → session → summary → progress
  [ ] Memory < 100MB during active session
  [ ] No crashes in last 24h of TestFlight feedback
```

If no physical devices available: Mark says "skip device checks" to proceed.
Items marked [SKIP] appear under KNOWN ISSUES in Step 4.

## Step 2: Bump build number

### Primary (dev-tools available)
Build number and version are already read from testflight-preflight.sh output (gate: build-bump).
Store: CURRENT_BUILD = gates.build_bump.old_build, NEW_BUILD = gates.build_bump.new_build, VERSION.
Run: `bash ~/projects/claude-dev-tools/kit/build-bump.sh --json`
Read JSON: old_build, new_build, bumped. Verify bumped == true.

### Fallback
Run: `agvtool what-version -terse` to get current build number.
If agvtool not configured: `grep -r 'CURRENT_PROJECT_VERSION' *.xcodeproj/project.pbxproj | head -1`
Store: CURRENT_BUILD, NEW_BUILD = CURRENT_BUILD + 1.
Run: `agvtool new-version -all $NEW_BUILD`
If agvtool not configured: update CURRENT_PROJECT_VERSION in project.pbxproj directly.
Read marketing version: `agvtool what-marketing-version -terse1`
If that fails: `grep -r 'MARKETING_VERSION' *.xcodeproj/project.pbxproj | head -1`
Store: VERSION.

## Step 3: Generate "What to Test" summary

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

## Step 4: Present for approval

Render via box-table.sh. Substitute all placeholders with actual values.

```bash
echo -e "BUILD | v{VERSION} (build {NEW_BUILD}) -- was build {CURRENT_BUILD}\nBRANCH | {current branch}\n\n## PRE-FLIGHT\n{gate_name} | {GO/NO-GO -- details}\n{gate_name} | {GO/NO-GO -- details}\n...\n\n## DEVICE CHECKS\n{item} | {OK/SKIP/FAIL}\n{item} | {OK/SKIP/FAIL}\n...\n\n## WHAT'S NEW (for testers)\n{plain English description of each change}\n{one line per item}\n\n## KNOWN ISSUES\n{open P1/P2, skipped device checks, or: None}\n\nApprove, edit, or cancel?" \
  | bash ~/projects/claude-dev-tools/kit/box-table.sh --title "SHIP -- TestFlight Build"
```

If `box-table.sh` is not available, fall back to plain-text `=== ===` format.

Wait for response:
- **approve / go / yes**: proceed to Step 5.
- **edit**: Mark provides modified summary. Re-present with edits. Wait again.
- **cancel**: revert build number bump (`agvtool new-version -all $CURRENT_BUILD`), stop.

## Step 5: Commit, tag, push

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

## Bridge Summary

If `BRIDGE_SESSION` is set (running via /bridge), append to summary file:
```
echo '{"protocol_version":1,"command":"/ship","status":"[complete/blocked]","emoji":"[:rocket:/:no_entry_sign:]","summary":"v[VERSION] b[BUILD] — [shipped/blocked: reason]","detail_lines":["[what to test summary]"],"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
```
