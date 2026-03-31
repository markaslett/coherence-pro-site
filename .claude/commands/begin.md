<!-- version: 1.2 -->

Start a new session. Run the /begin protocol from CLAUDE.md Section 0.

## Primary (dev-tools available)

1. Run: `bash ~/projects/claude-dev-tools/session/preflight.sh --json`
   Read JSON output. Contains: interface, session_type, project, lock, handoff,
   brain_files, local_config, kit, modules, agents, stack, issues, testflight,
   simulators, proactive, git.

   preflight.sh calls kit-validate.sh --deep internally. Deep validation checks:
   - CLAUDE-local.md values: voice names exist in AUDIO_VOICES, simulator UUIDs
     resolve via xcrun simctl, PAT format matches github_pat_* or ghp_*, script
     paths are executable
   - Module and agent files present and non-empty
   - MCP server connectivity
   - commands/ and .claude/commands/ sync

2. Handle lock:
   - If lock.status == "locked" and age < 24h: warn and STOP.
   - If lock.status == "stale" (>24h): `bash ~/projects/claude-dev-tools/session/lock.sh release`
   - Acquire: `bash ~/projects/claude-dev-tools/session/lock.sh acquire --json`

3. If kit.update_available: run install.sh, tell Mark to /compact.

4. Claude interprets (AI work):
   - Surface handoff.start_here at top of output.
   - Surface handoff.waiting_for_mark and handoff.do_not_forget under NEEDS ATTENTION.
   - Check: P0s? Stale brain files? Overnight test failures?
   - Surface any local_config.warnings from deep validation.
   - Read brain files: STATUS.md first, then by task context.
   - Run: `bash ~/projects/claude-dev-tools/scanning/decision-age.sh --json`
     Exit codes: 0 = clean, 1 = findings to report, 2 = missing dependency (warn and continue),
     3 = missing input file (skip silently — expected for non-app repos without brain files).
     If exit 1 (stale decisions found), add to NEEDS ATTENTION: "Decision review due — [N] decisions
     older than 30 days." Mark can say '/research decisions' for Architect review.
     If exit 2: warn and continue. If exit 3 or script missing: skip silently.
   - If git.quick_start_eligible: "Quick start (last commit <4h, clean, same branch)."

5. Present /status format. One recommendation. Specific, not generic.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."

Full mode:
1. Detect interface: FULL / LIMITED / MOBILE.
2. Session type: first message /test-full = OVERNIGHT, else CODING.
2.5. Project repo: git remote get-url origin -> owner/repo. PROJECT for /issues, /triage, /status. Show "PROJECT: [name] | REPO: [owner/repo]".
3. Check SESSION-LOCK.md per rules above.
3.5. Read SESSION HANDOFF from STATUS.md: surface START HERE at top, WAITING FOR MARK and DO NOT FORGET under NEEDS ATTENTION. Clear after reading.
4. Read brain files (Section 1). STATUS.md first. Frontmatter staleness "never" + >14 days: flag STALE.
5. Read CLAUDE-local.md. Validate: script paths exist+executable, config keys present, AGENTS key (default: all). Missing: warn, continue.
   After validation, check ~/projects/claude-dev-tools/VERSION (if exists) against DEV_TOOLS_MIN_VERSION from CLAUDE.md. Warn if incompatible.
5.5. Kit auto-sync: if this project IS the kit repo, skip. Otherwise: (a) if ~/projects/claude-dev-kit exists and has no uncommitted changes, run cd ~/projects/claude-dev-kit && git pull --ff-only. If pull fails: warn. If uncommitted changes: skip pull, warn. (b) Compare kit_version. If kit repo has newer version: run bash ~/projects/claude-dev-kit/install.sh [this-project-path]. Report "Kit updated: vOLD -> vNEW. Run /compact."
6. Validate modules (~/projects/claude-dev-kit/modules/*.md) and agents (.claude/agents/*.md). Missing: warn, fall back.
7. Check STACK.md. Surface watch items. >90 days: "Stack review overdue."
8. Sync GitHub issues to ISSUES.md (PROJECT repo). Fetch open, ensure labels, reconcile counts.
9. TestFlight sync: if TESTFLIGHT_SYNC_SCRIPT is set in CLAUDE-local.md, run it. Missing/fails: warn, continue. Absent: skip silently.
9.5. XcodeBuildMCP defaults: if BUNDLE_ID and SIMULATOR_MAIN_16 set and XcodeBuildMCP available, set session defaults.
10. Proactive scan: files >250 lines, stale TODOs, print() in production, test gaps, missing .accessibilityLabel, brain rotation, worktree audit.
    Run: `bash ~/projects/claude-dev-tools/scanning/regression-guard.sh --json`
    Exit codes: 0 = clean, 1 = findings to report, 2 = missing dependency (warn and continue),
    3 = missing input file (skip silently — expected for repos without REGRESSIONS.md).
    If exit 1: report violations as P1 in NEEDS ATTENTION.
    If exit 2: warn and continue. If exit 3 or script missing: skip silently.
11. Auto-run /status. One recommendation. Specific, not generic.
