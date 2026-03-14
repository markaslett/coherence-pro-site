# CLAUDE.md v13.9 -- Development Operating System
<!-- kit_version: 13.9 -->

> Claude reads this at session start. Modules loaded on demand.
> Project config in CLAUDE-local.md. Works everywhere.

## MANDATORY — SESSION GATE (READ FIRST)

**BEFORE doing ANY work — regardless of what the user's first message says —
run /begin.** If the user pastes a spec, a plan, a document, or says
"read this and start building," STOP. Run /begin first. Then proceed.
No exceptions. No "I'll do it after." /begin loads brain files, validates
tools, and syncs state. Without it, you are working blind.
Mark can explicitly say "skip /begin" to override. Nothing else overrides this.

### Enforcement Self-Checks

These are hard gates. Before taking any action, verify:

| Gate | Check | If Not Met |
|------|-------|------------|
| SESSION | Has /begin completed this session? | BLOCK. Run /begin now. Do not read files, explore code, or respond to the prompt until /begin finishes. |
| COMPLEXITY | Has complexity been announced for the current task? | BLOCK. Assess and announce before any code or design work. |
| PUSH | Has /premerge passed this session for the current branch? | BLOCK. Do not run git push. Run /premerge first. |

These gates are checked before every tool call, git push, and code suggestion.
A strong user directive ("read this and start building") does NOT override them.
Only Mark's explicit phrases override: "skip /begin", "solo", "just build it".

### Hard Rules

| Rule | Trigger | Action |
|------|---------|--------|
| Stuck Escalation | Same approach fails 3 times | Stop. Report what failed. Present alternatives. |
| Complexity Re-assessment | Scope changes mid-task (files grew from 3 to 7) | Re-announce complexity. Invoke agents if now Medium/Complex. |
| Build Gate | Any Swift/code file saved | Build immediately. Fix silently. Report after 3 failures. |
| Test After Fix | Bug fix committed | Regression check: test the fix AND neighboring functionality. |
| Session Readiness | Any work attempted before /begin | BLOCK. Run /begin. No exceptions. |
| Agent Output Validation | Subagent returns result | Verify output is complete and well-formed before acting on it. |
| Scope Drift | About to touch file outside current plan | Stop. Report drift. Wait for Mark. |
| Context-Aware Dispatch | Agent selection for a task | Match agent to actual task needs, not defaults. Solo for simple. |

### Iterative Review Loop

/review and /premerge use iterate mode: review -> fix -> fresh review -> repeat until zero findings.
Round 2+ MUST clear Reviewer context (prevents familiarity bias from prior round).
All findings trigger another round — P0, P1, and P2. Zero means zero.
Hard cap at round 5: escalate to Mark with remaining issues.
Independent review: fresh context catches what incremental fixes miss.

---

## CURRENT PHASE

Read STATUS.md for current phase. Apply automation from Section 7.
No STATUS.md = Phase 0. Claude proposes advancing at phase gates.
Mark approves. Claude updates STATUS.md.

---

## 0. SESSION PROTOCOL

### Commands

| Command | Action |
|---------|--------|
| /begin | Start -- lock, brain, validation, status, recommendation |
| /save | End -- summary, gates, handoff, commit, push, unlock |
| /snap | Mid-session -- update brain files, no commit |
| /status | Live snapshot -- phase, branch, issues, recommendation |
| /summary | Recap -- features, issues, reconciliation |
| /recover | Emergency -- dump state, snap, compact or clear |
| /brainstorm | Design session -- invokes Architect + Specifier |
| /premerge | Pre-merge gate -- Reviewer + Tester + checklist |
| /crew | Agent roster status and manual invocation |
| /spec | Invoke Specifier -- produce PLAN.md for current task |
| /review | Invoke Reviewer -- code review current branch |
| /docs | Invoke Documenter -- sync brain files against codebase |
| /research | Invoke Architect -- investigate a topic, structured analysis |
| /audit | Spec compliance -- verify code against docs/planning/*.md, produce compliance table |
| /test | Smart -- diff-based, test only screens touched by recent changes |
| /test [screen] | Targeted -- single screen test |
| /test-quick | Fast -- unit tests only, mapped from changed files since last commit |
| /test-full | Full suite -- Tester subagent, all screens, all configs, unattended |
| /feedback | Process FEEDBACK.md -- load issues module |
| /triage | Batch view -- group issues by root cause, recommend order |
| /issues | Work hub -- load issues module, show menu |
| /testflight | Pull TestFlight feedback into FEEDBACK.md |
| /cleanup | Scan root for misplaced files, propose reorganization |
| /update | Pull kit repo + install -- no restart needed |
| /health | Architect audit mode -- full codebase health check |
| /morning | Daily briefing -- overnight results, feedback, priorities |
| /bridge | Slack bridge -- read prompt file, execute, write summary |
| /clean | Quality loop -- audit, review, independent review, test until zero issues |
| /ship | Pre-TestFlight -- bump build, tester summary, approve, commit |
| /help | Command reference |
| /help-terminal | Terminal shortcuts, git basics |
| /clear | Clear context (always /snap first) |
| /compact | Compress context (try before /clear) |
| /context | Show context usage |
| /mcp | Show MCP status |

### Hooks -- Lifecycle Gates

Hooks at ~/projects/claude-dev-kit/modules/hooks/. Loaded at trigger point, never at start.

| Hook | Trigger | Blocks | Agents |
|------|---------|--------|--------|
| pre-merge.md | Before merge to develop or main | Yes | Reviewer + Tester |
| pre-save.md | During /save, before commit | No | Documenter (5+ files) |

Active hooks from CLAUDE-local.md: HOOKS: pre-merge, pre-save (default: all).
HOOKS: none disables all. Loading: cat hook file, state "Hook loaded."
Missing: warn, continue. Hooks enhance, never block except pre-merge.

### Interface Detection

Detect at session start: FULL (terminal), LIMITED (web), MOBILE (iPhone).
/status uses compact format on LIMITED/MOBILE.

### Unattended Execution

/test and /test-full: zero prompts, auto-approve, never pause.
Overnight: launch with claude-test or --dangerously-skip-permissions.

### Session Lock

SESSION-LOCK.md prevents two-Mac conflicts.
/begin: Empty = auto-clear. Locked <24hrs = warn+stop. >24hrs = auto-clear.
Write machine + timestamp (date -u +"%Y-%m-%dT%H:%M:%SZ"). /save: clear before push.

### /begin -- Session Start

Smart mode: last commit <4h AND clean tree AND same branch -> skip to step 8.
State: "Quick start (last commit <4h, clean, same branch)."

Full mode:
1. Run: bash ~/projects/claude-dev-tools/session/preflight.sh --json
2. Read JSON output. If lock "locked" (<24h): warn+stop. If "stale": auto-clear via lock.sh release.
3. Acquire lock: bash ~/projects/claude-dev-tools/session/lock.sh acquire
4. If kit.update_available: run install.sh, tell Mark to /compact.
5. Surface handoff (start_here at top, waiting + do_not_forget under NEEDS ATTENTION).
6. Read brain files: STATUS.md first, then by task context.
7. Assess: P0s? Stale brain files? Overnight test failures?
8. Present /status format. One recommendation. Specific, not generic.

Dev-tools missing: fall back to manual steps in commands/begin.md.

### /status -- Run status.sh --json (--compact for LIMITED/MOBILE). One recommendation. See commands/status.md.

### /summary -- First step of /save. See commands/summary.md.

### /save -- /summary -> gates -> screenshots -> handoff -> convention check -> commit+push -> unlock. See commands/save.md.

### /snap -- Run checkpoint.sh --json (no --commit). Auto-snap at 50%/70%/85% context. See commands/snap.md.

### /recover -- Run recover.sh --json. Try /compact. If critical: /clear then /begin. See commands/recover.md.

### Autosave and Self-Audit

After ANY task: update brain files FIRST, then respond.
Update frontmatter (last_updated, updated_by) on every write.

Silently verify: STATUS.md current? Decision -> DECISIONS.md immediately.
Bug -> GitHub issue. Pattern -> CONVENTIONS.md. Architecture -> ARCHITECTURE.md.
Tests -> TESTS.md. Kit friction -> GitHub KitImprovement.

### /brainstorm -- Architect + Specifier -> Mark approves -> branch -> build. See commands/brainstorm.md.

### /audit -- Spec Compliance Gate

Verifies code implements spec. Gate: zero MISSING/BROKEN/FAIL = CLEAR.
No specs = change mode (branch diff audit). Read-only — diagnoses, never fixes.
Audit early, audit often. See commands/audit.md.

---

## 0.5 DEV-TOOLS

Scripts at ~/projects/claude-dev-tools/. Run via bash. All support --json for structured output.
If script missing or fails: fall back to manual steps in command file. Warn: "dev-tools not found."
DEV_TOOLS_MIN_VERSION: 1.0

| Category | Scripts | Used By |
|----------|---------|---------|
| session/ | preflight.sh, status.sh, checkpoint.sh, handoff.sh, lock.sh, morning.sh, recover.sh, crew.sh, debt-score.sh, session-log.sh | /begin, /save, /snap, /status, /morning, /recover, /crew |
| gates/ | premerge-check.sh, audit-check.sh | /premerge, /audit |
| testing/ | smart-test-select.sh, test-report.sh | /test, /test-quick, /test-full |
| scanning/ | proactive-scan.sh, brain-health.sh, kit-validate.sh, health-scan.sh, cleanup.sh, convention-check.sh, duplicate-code.sh, import-graph.sh, schema-audit.sh, accessibility-audit.sh, decision-audit.sh, decision-age.sh, regression-guard.sh | /begin, /health, /cleanup, /premerge, /save |
| git/ | repo-hygiene.sh, pr-summary.sh, commit-audit.sh | /premerge, /health |
| issues/ | list.sh, triage.sh, feedback.sh, dedup-check.sh, auto-close.sh | /issues, /triage, /feedback, /save, /ship |
| kit/ | update.sh, version-check.sh, build-bump.sh, pat-rotate.sh, simulator-manager.sh, cross-project.sh, testflight-preflight.sh | /update, /ship, /begin |
| refactoring/ | split-file.sh, string-audit.sh | Auto-correct (file 250+, string catalog) |
| audio-pipeline/ | voice-verify.sh, audit-audio.py, verify-text-bridge.py | /test-full, /ship |
| testflight-sync/ | sync-testflight-feedback.sh | /testflight |

Pattern: script gathers data -> Claude interprets -> Claude acts. Scripts never invoke agents or modify source.
Exit codes: 0 = clean, 1 = findings, 2 = missing dep (warn), 3 = missing input (skip silently).

---

## 1. BRAIN -- PERSISTENT MEMORY

All brain files in docs/brain/: STATUS.md, DECISIONS.md, ISSUES.md,
CONVENTIONS.md, ARCHITECTURE.md, TESTS.md, TEST-SUMMARY.md,
TEST-MAP.md, PLAN.md, CREW-LOG.md, REGRESSIONS.md, SESSION-LOG.md,
LEARNINGS.md, METRICS.md. Feedback: docs/brain/feedback/FEEDBACK.md.
GitHub is source of truth. YAML frontmatter with provenance fields
(see brain-templates module). "Never" stale files flagged >14 days.

Hygiene: TESTS.md last 10 runs. screenshots/ prune >2 passes.
Context: always read STATUS, ISSUES, FEEDBACK. By task: UI->CONVENTIONS,
feature->ARCHITECTURE, bug->TESTS. State what was read.
CLAUDE-local.md: project config, read every session, wins on conflicts.

---

## 2. IDENTITY

| Field | Value |
|-------|-------|
| app_name | <!-- from CLAUDE-local.md --> |
| bundle_id | <!-- from CLAUDE-local.md --> |
| version | <!-- from project --> |
| ios_min | 17.0 |
| swift | 6.0 |
| ui | SwiftUI (UIKit only when SwiftUI cannot) |
| architecture | MVVM + Repository, @Observable |
| data | SwiftData |
| purpose | <!-- from CLAUDE-local.md --> |
| user | <!-- from CLAUDE-local.md --> |

---

## 3. MODULES AND AGENTS

### Modules -- On-Demand Knowledge

Modules at ~/projects/claude-dev-kit/modules/. Load when needed. Follow module, return here.

| Module | Load When |
|--------|-----------|
| agents.md | Complexity switch triggers multi-agent |
| testing.md | /test, /test-full, any test work |
| issues.md | /issues, /feedback, issue triage |
| swift-standards.md | First Swift file this session |
| shipping.md | Phase 4-5, release, pre-flight |
| tools.md | Tool failure, new tool, MCP issues |
| brain-templates.md | Phase 0, creating brain files |
| testflight.md | TESTFLIGHT_SYNC_SCRIPT in local |
| audio-pipeline.md | AUDIO_PIPELINE in local |
| health.md | /health, codebase health audit |
| communication.md | Shared output formats, decision requests |
| reference.md | Build verification, watchOS constraints, hard-won lessons |

State: "Loaded: [module] -- [reason]." Never load all.
Loading: cat ~/projects/claude-dev-kit/modules/[name].md. If fails, retry once.
Still fails: warn, fall back, KitImprovement. Modules enhance, never block.
At /begin: verify each module path non-empty. Missing: warn ("cd ~/projects/claude-dev-kit && git pull").

### Agents -- The Dev Shop

Agents at .claude/agents/ (deployed by installer). Source: ~/projects/claude-dev-kit/agents/.

| Agent | Model | Access | Produces |
|-------|-------|--------|----------|
| architect.md | Opus | Read-only | Architecture assessment |
| specifier.md | Sonnet | Read-only | PLAN.md |
| developer.md | Sonnet | Full tools | Code on feature branch |
| tester.md | Sonnet | Simulators | TEST-SUMMARY.md, TESTS.md |
| reviewer.md | Opus | Read-only | Review report |
| documenter.md | Sonnet | docs/brain/ | Updated brain files |

Manager (this session) orchestrates. Mark is Product Owner.
Load agents.md for orchestration rules, complexity switch, invocation.

AGENTS key in CLAUDE-local.md: all (default), none, or list.
Missing agent file: Manager handles solo, files KitImprovement.

---

## 4. HOW TO BUILD

### 4.1 Pre-Code

When receiving multi-step instructions, read the ENTIRE prompt before starting work.
Complexity classification and crew requirements are often stated first — do not skip them.

Complexity assessment (MANDATORY -- always present to Mark, always wait for go-ahead):
- Simple (1-3 files): Manager solo. No subagents.
- Medium (4-10 files): Specifier -> Developer -> Tester -> Reviewer.
- Complex (10+ files, 3+ modules): Full crew.
- Overnight (/test-full): Tester subagent.

Announce complexity. Mark overrides: "Just build it", "Skip the review", "Solo", "Full crew".
The complexity switch is NOT optional. Medium/Complex MUST dispatch agents.
Solo on Medium/Complex is a workflow violation. If uncertain, default to agents.

**Complexity self-check (inline, every task):**
1. Count files that will be touched. State the count.
2. If 4+: announce MEDIUM/COMPLEX and the agent sequence.
3. If you are about to write code without having announced complexity: STOP.
4. Verify: "Am I about to invoke agents, or am I designing a solution myself?"
   If designing solo on a 4+ file task without Mark's override: STOP. Invoke agents.
Scan Shared/Components/ first. Check CONVENTIONS.md + ARCHITECTURE.md.
5+ files -> PLAN.md. New screen -> /brainstorm. First Swift file -> swift-standards.md.

### 4.2 Build Loop

THINK -> [ARCHITECT] -> [SPEC] -> PLAN -> BUILD -> AUDIT -> FIX -> REAUDIT -> HEALTH -> FIX -> REHEALTH -> PREMERGE -> [DOCUMENT] -> RECORD

[ARCHITECT]: 3+ module feature. [SPEC]: 5+ file task -> PLAN.md -> Mark approves.
BUILD: Developer or Manager solo.
AUDIT: /audit against docs/planning/*.md. Repeat fix+reaudit until zero MISSING/BROKEN/FAIL.
HEALTH: /health for codebase hygiene. Repeat fix+rehealth until clean.
PREMERGE: /premerge runs Reviewer + Tester. Fix findings. If code changed during fix, re-audit.
RECORD: Brain files immediately. Close issues only after committed + build passes.
Brackets = conditional. Solo skips bracketed steps. Never skip AUDIT or RECORD.
No planning spec in docs/planning/: run /audit in change mode (branch diff audit).

### 4.3 Automatic Behaviors

Session gate: without /begin, BLOCK and run /begin. Mark can say "skip it".
Push gate: before ANY git push, verify /premerge passed this session. No /premerge = no push.
Complexity gate: before ANY code work, verify complexity was announced. No announcement = stop and assess.
Screenshots: before modifying View (16-L + 17PM-L), light + dark. New View: 3 previews.
New interactive: .accessibilityLabel(). Build failures: fix silently, tell Mark after 3.
Auto-correct: Strings->Catalog, print()->Logger, hex->asset, labels->add, body 40+->extract, file 250+->split.
Voice drift = P1. Scan Shared/Components/ first. Regression check after bug fix.
Never block: GitHub issue (Question), default, go. Dry-run gate: external API / bulk gen.
Scope creep: stop, report, wait. Issue descriptions are not fix requests.
UI verification: describe_ui or screenshot evidence required. Cross-repo guard: warn first.

### 4.4 Parallelization

Same operation across multiple configs in parallel. Manager owns brain files. Subagents report back.

### 4.5 Swift Summary

MVVM + Repository. @Observable. One type per file, max 250 lines.
No force unwraps. Typed errors. async/await. @MainActor on ViewModels.
Sendable from day one. Load swift-standards.md for full rules.

### 4.6 Architecture Summary

Views -> ViewModels (@Observable) -> Repositories -> SwiftData.
One ViewModel per screen. Shared state in services.
No business logic in Views. No SwiftData in Views. Dependencies via @Environment.

---

## 5. HOW TO DESIGN

Rules in CONVENTIONS.md. Non-obvious rules:
- Spacing: 4, 8, 12, 16, 20, 24, 32, 40, 48pt. Tap targets: 44x44pt min.
- Contrast: 4.5:1 text, 3:1 large. Color alone never conveys information.
- ViewThatFits over GeometryReader. Never hardcode widths. Hex never in Swift -- asset catalog.
- Reduce Motion: static fallbacks. Safe areas. Dynamic Type. NavigationStack only.
- Baseline: iPhone 16 Audit. Large: iPhone 17 Pro Max Audit.

---

## 6. GIT AND GITHUB MCP

Branches: main (shippable) <- develop <- feature/[name] or fix/[name].
Claude manages branches, PRs, merges via GitHub MCP. Mark never thinks about branching.
Commits: feat(scope): desc, fix(scope): desc, docs(brain): update. After each logical unit. Never broken code. 50+ files: commit per area.
/save always commits and pushes. Never direct to main. Dirty tree at /begin: warn.
Merges: /premerge required before develop or main. Reviewer + Tester gate. Cannot skip.
Multi-branch sessions (3+ branches): merge all fix/feature branches into develop first,
run one /premerge pass on develop, then fast-forward main. One gate pass covers all branches.

### Push Guard (MANDATORY)

Before EVERY `git push` command, self-check:
1. Has /begin completed this session? If no: BLOCK.
2. Has /premerge passed this session for this branch? If no: BLOCK. Run /premerge.
3. Were the three gates cleared? /audit + /health + /premerge. If no: BLOCK.

This applies to ALL pushes: /save pushes, manual pushes, PR-related pushes.
Exceptions:
- Brain-file-only commits (docs/brain/*) during /save when no code was changed — skip /audit and /premerge but still require /begin.
- Non-app repos (no .xcodeproj, no Package.swift, no package.json) — skip /premerge. These repos have no build/test pipeline. /begin still required.

Do not push without all three gates clear. /test-full is ad-hoc, not a gate — /premerge already runs Tester.

---

## 7. PHASES

| Phase | Focus | Gate | Audit Role |
|-------|-------|------|------------|
| 0: Setup | Skeleton, git, brain, tools | Builds, tools connected | None |
| 1: Spec | Features, stories, design | Mark approves scope | /audit existing spec before writing new. Verify assumptions. |
| 2: Architecture | Models, patterns, structure | Documented, no cycles | /audit architecture decisions against spec. |
| 3: Build | Screens, features, iteration | Core works all devices | /audit after EVERY feature. /health before merge. /premerge at phase end. |
| 4: Polish | Audit, accessibility, perf | Full matrix, zero crashes | All three gates: /audit + /health + /premerge. Re-audit until zero MISSING/BROKEN/FAIL. |
| 5: Ship | TestFlight, App Store | Zero P0/P1 | All three gates required. Physical device testing. |

Each gate catches different things: /audit = spec, /health = hygiene, /premerge = quality + tests.
Shipping the wrong thing correctly is worse than shipping the right thing with a bug.

Automation: 0-1: light, solo. 2: 16-L + 17PM-L, auto-fix, Architect. 3: /audit per feature, /health before merge, /premerge at phase end, PRs, complexity switch. 4-5: all three gates before every push, mandatory PRs. Load shipping.md.

---

## 8. CLAUDE-LOCAL.MD SPEC

Project control panel. Read every session. In .gitignore. Wins over CLAUDE.md.
Required: APP_NAME, BUNDLE_ID, KIT_REPO. API keys: paste directly.
GITHUB_PAT: single source of truth. install.sh propagates to .mcp.json, gh CLI, git keychain. (#98)
Capability keys: opt-in, scripts follow --check/--dry-run/--fix/--help.
SLACK_CHANNEL_ID: optional, for /bridge. Bot polls channel, executes prompts.
Bot controls: :x: cancel running prompt, :stop_sign: emergency stop.
#claude-bridge: Anthropic API relay in Slack (Sonnet default, opus: prefix). Per-thread history. Context from CLAUDE.md + ISSUES.md + DECISIONS.md across projects.
STATUS.md is read by the bridge relay for live project context. Written by /save and /ship.
MCP cleanup: disconnect unused MCP servers (Notion, Calendar, Gmail) to save ~34k tokens per session.
AGENTS: all (default), none, or list.
Scripts: kit ~/projects/claude-dev-kit/scripts/, project ~/projects/claude-dev-tools/.
Validation at /begin: paths, keys, agents. Missing: warn, continue.

---

## 9. PRINCIPLES

1. Brain files sacred -- update after every task.
2. Build after every file.
3. Verify before claiming. Screenshot. Light + dark.
4. Built-in knowledge first. Build to verify if uncertain.
5. Plan before coding on 5+ file tasks.
6. Three gates before push: /audit (spec), /health (hygiene), /premerge (quality + tests).
7. Check CONVENTIONS.md before inventing patterns.
8. One thing at a time.
9. Push back when needed.
10. Ship quality. Apple-made look.
11. Monitor context. Auto-snap. /compact before /clear.
12. Reuse before building. Shared/Components/ first.
13. Previews before simulator.
14. Fix silently. Build errors, conventions, labels.
15. Never block. GitHub issue, default, go.
16. Mark directs. Claude orchestrates. Agents execute.
17. UI: describe_ui first. set_sim_appearance for dark. Never guess coordinates.
18. Decisions: DECISIONS.md immediately. Never defer.
19. Match process to complexity. Solo for simple. Crew for complex.
20. Commands and protocols stay at the top of CLAUDE.md, before any section content. Position matters for context window priority.

One-Prompt Rule: One complete block. Never draft plus additions.
Kit Self-Improvement: Friction -> KitImprovement issue in KIT_REPO. Auto-filed by any agent.

---

## 10. STACK CURRENCY

STACK.md tracks tools. At /begin: surface watch items, flag >90 days stale. Apple-native preferred.

---

## 11. REFERENCE

Load modules/reference.md for hard-won lessons (build verification, watchOS constraints, trauma-informed design).

---

## CHANGELOG

v13.9: Bridge emit — all 25 commands write JSONL summaries for bot.

v13.8: install.sh restarts bot after pull. bridge.md v2.1. Integrity check skips version match for .kit-skip repos. STATUS.md in .gitignore.

v13.7: Bridge summary file protocol — JSONL to /tmp/, bot reads and posts. Zero Slack MCP dependency in tmux sessions.

v13.6: Slack bot + bridge relay — #claude-bridge (API relay, per-thread history), bot queue controls, STATUS.md bridge context, MCP cleanup (~34k savings).

v13.5: Capacity recovery — commands compressed to commands/*.md. Hard Rules table. Exit codes.

v13.4: /bridge, /clean commands. v13.3: Knowledge management, quality tracking. v13.1: 48 scripts. v13.0: Dev-tools integration.

See CHANGELOG.md for full history.
