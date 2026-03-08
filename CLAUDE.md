# CLAUDE.md v12.0 -- Development Operating System
<!-- kit_version: 12.0 -->

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
1. Detect interface: FULL / LIMITED / MOBILE.
2. Session type: first message /test-full = OVERNIGHT, else CODING.
2.5. Project repo: git remote get-url origin -> owner/repo. PROJECT for /issues, /triage, /status. KIT_REPO for KitImprovement only. Show "PROJECT: [name] | REPO: [owner/repo]".
3. Check SESSION-LOCK.md per rules above.
3.5. Read SESSION HANDOFF from STATUS.md: surface START HERE at top, WAITING FOR MARK and DO NOT FORGET under NEEDS ATTENTION. Clear after reading.
4. Read brain files (Section 1). STATUS.md first. Frontmatter staleness "never" + >14 days: flag STALE.
5. Read CLAUDE-local.md. Validate: script paths exist+executable, config keys present, AGENTS key (default: all). Missing: warn, continue.
5.5. Kit auto-sync: if this project IS the kit repo, skip. Otherwise: (a) if ~/projects/claude-dev-kit exists and has no uncommitted changes, run cd ~/projects/claude-dev-kit && git pull --ff-only. If pull fails (offline or diverged): warn "Kit repo pull failed — running on local version. Fix: cd ~/projects/claude-dev-kit && git pull". If uncommitted changes: skip pull, warn "Kit repo has local edits — skipping auto-sync." (b) Compare kit_version in this project's CLAUDE.md against ~/projects/claude-dev-kit/CLAUDE.md. If kit repo has a newer version: run bash ~/projects/claude-dev-kit/install.sh [this-project-path]. Report "Kit updated: vOLD -> vNEW. Run /compact to pick up new instructions." If versions match or kit repo unreachable: skip silently. (#93, #95, #96)
6. Validate modules (~/projects/claude-dev-kit/modules/*.md) and agents (.claude/agents/*.md). Use bash -c. Missing: warn, fall back, KitImprovement.
7. Check STACK.md. Surface watch items. >90 days: "Stack review overdue."
8. Sync GitHub issues to ISSUES.md (PROJECT repo). Fetch open, ensure labels, reconcile counts. last_issue in STATUS.md: "Resume #N?" GitHub unreachable: warn, continue.
9. TestFlight sync: if TESTFLIGHT_SYNC_SCRIPT is set (uncommented) in CLAUDE-local.md, run it. Script missing or not executable: warn, continue. Script fails: warn with exit code, continue. Key commented out or absent: skip silently. (#75)
9.5. XcodeBuildMCP defaults: if BUNDLE_ID and SIMULATOR_MAIN_16 are set in CLAUDE-local.md and XcodeBuildMCP MCP server is available (/mcp), invoke the XcodeBuildMCP MCP tool to set session defaults with bundleId from BUNDLE_ID and simulatorId resolved from SIMULATOR_MAIN_16 device name (xcrun simctl list devices available | grep '<device-name>' | extract UUID). Device not found: warn, skip. Missing keys or no XcodeBuildMCP: skip silently. Also resolve SIMULATOR_MAIN_WATCH if set — same UUID lookup for watchOS simulator. Store both iPhone and Watch simulator IDs for the session. (#76, #91)
10. Proactive scan: files >250 lines, stale TODOs (>5 sessions), print() in production, test gaps, missing .accessibilityLabel (P1), brain rotation, worktree audit. Bash: relative paths, | xargs not -exec.
11. Auto-run /status. /begin output IS /status output. OVERNIGHT: append "OVERNIGHT MODE active."

### /status -- Live Snapshot

Reads: STATUS.md, ISSUES.md, TESTS.md, PLAN.md, FEEDBACK.md (full if <200 words, count if over), CLAUDE.md version.
Git: status, branch, log -5, commits behind, /mcp check.
Shell: Never $() inside Bash. Run separately, capture, pass as literals.
Bash: Relative paths. | xargs not -exec {} \;.

FULL: PROJECT, REPO, PHASE, BRANCH, INTERFACE, CREW, NEEDS ATTENTION, ISSUES, FEEDBACK, TESTS, LAST SESSION, ACTIVE PLAN, STACK, KIT, RECOMMENDED.
COMPACT (LIMITED/MOBILE): Project | phase | branch | crew | critical | issues | next.
P0/P1/Questions/TestFailures/Worktrees/Stale brain: NEEDS ATTENTION.
One recommendation. Specific, not generic.

### /summary -- Session Recap

First step of /save. Also on demand. Shows: FEATURES, ISSUES CLOSED, DECISIONS, COMMITS, FILES CHANGED, TESTS, AGENTS USED, STILL OPEN, RECONCILIATION. [!] requires "save anyway" before /save proceeds.

### /save -- End Session

1. /summary. 2. Gates: reconciliation [!], FEEDBACK, P0. 3. Screenshots.
3.5. Pre-save: DECISIONS.md audit, SESSION HANDOFF (START HERE, WAITING FOR MARK, DO NOT FORGET, CREW ACTIVITY), pre-save hook (Documenter on 5+ files).
4. Convention/architecture check. 5. Worktree cleanup. 6. Commit, push.
6.5. Issue auto-close: scan session commits for issue references (#NNN). For each
referenced issue fixed this session, close on GitHub via MCP with 2-sentence summary.
Use commit context to write the close message. Update ISSUES.md cache. Report: "Closed: #N, #N."
7. "Saved. [N] files. [hash]. Lock released."

### /snap -- Mid-Session

Scope to changed files. Update brain files touched by session diff.
Skip screenshots if no View files in git diff. No commit.
Auto-snap: after feature/fix, before /test, before branch switch.
50%: silent. 70%: notify. 85%: warn to finish then /compact or /clear.

### /recover -- Emergency

Write state to STATUS.md. /snap all brain files. Try /compact.
If not enough: "Context critical. /clear then /begin." Stop.

### Autosave and Self-Audit

After ANY task: update brain files FIRST, then respond.
Update frontmatter (last_updated, updated_by) on every write.

Silently verify: STATUS.md current? Decision -> DECISIONS.md immediately.
Bug -> GitHub issue. Pattern -> CONVENTIONS.md. Architecture -> ARCHITECTURE.md.
Tests -> TESTS.md. Kit friction -> GitHub KitImprovement.

### /brainstorm -- Design Session

Before significant features, screens, or architecture changes.
Architect (assessment) + Specifier (PLAN.md) -> Mark approves -> branch -> build.

### /audit -- Spec Compliance Gate

Verifies code implements what the planning spec says. Mandatory when docs/planning/*.md exists.
No specs = runs change mode (branch diff audit). All six agents, four phases for spec mode:

1. **Specifier** — extracts numbered, individually testable requirements (R1, R2...) from specs. This is the checklist.
2. **Architect + Tester + Documenter** (parallel) — Architect maps requirements to code, Tester maps to tests, Documenter maps to docs. Initial compliance table.
3. **Developer + Reviewer** (parallel, DONE/PARTIAL only) — Developer traces data flow end-to-end, Reviewer checks implementation quality. Downgrades if broken or unsafe.
4. **Manager** — merges all reports into final table. Worst status wins.

Gate: zero MISSING + zero BROKEN + zero FAIL = CLEAR. Anything else = fix and re-audit.
UNTESTED/UNDOCUMENTED surface as warnings but do not block.
Workflow: Code -> /audit -> fix -> reaudit (repeat until CLEAR) -> /health -> /premerge -> push.

/audit is read-only. It diagnoses, never fixes. The coding instance fixes, then re-runs /audit.
PARTIAL items are noted but do not block. Only MISSING/BROKEN/FAIL block.
Audit early, audit often: run /audit after every coding session, not just feature completion.
Do not wait until all work is done. Catching spec gaps early prevents compounding rework.

### /audit change mode (no specs)

When docs/planning/ is empty or missing, /audit runs change mode — audits the branch
diff against the base branch for: test coverage, documentation gaps, regression risk,
and spec gaps (warning, not blocker). See commands/audit.md for full template.
Manager runs solo or with Reviewer for 10+ file diffs.

---

## 1. BRAIN -- PERSISTENT MEMORY

All brain files in docs/brain/: STATUS.md, DECISIONS.md, ISSUES.md,
CONVENTIONS.md, ARCHITECTURE.md, TESTS.md, TEST-SUMMARY.md,
TEST-MAP.md, PLAN.md, CREW-LOG.md. Feedback: docs/brain/feedback/FEEDBACK.md.
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
The complexity switch is NOT optional. If you identify a task as Medium or Complex,
you MUST dispatch the corresponding agents. Proceeding solo on a Medium or Complex
task is a workflow violation. If uncertain, default to agents.

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
The ONLY exception: pushing brain-file-only commits (docs/brain/*) during /save
when no code was changed — these skip /audit and /premerge but still require /begin.

Do not push without all three gates clear. /test-full exists for ad-hoc use but is not a separate pre-push gate -- /premerge already runs the Tester agent.

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

Principle: each gate catches different things. /audit catches spec violations. /health catches
codebase hygiene issues. /premerge catches code quality problems and test regressions.
Shipping the wrong thing correctly is worse than shipping the right thing with a bug.

Automation: 0-1: light, solo. 2: 16-L + 17PM-L, auto-fix, Architect. 3: /audit per feature, /health before merge, /premerge at phase end, PRs, complexity switch. 4-5: all three gates before every push, mandatory PRs. Load shipping.md.

---

## 8. CLAUDE-LOCAL.MD SPEC

Project control panel. Read every session. In .gitignore. Wins over CLAUDE.md.
Required: APP_NAME, BUNDLE_ID, KIT_REPO. API keys: paste directly.
Capability keys: opt-in, scripts follow --check/--dry-run/--fix/--help.
AGENTS: all (default), none, or list.
Scripts: kit ~/projects/claude-dev-kit/scripts/, project ~/projects/dev-tools/.
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

## 11. REFERENCE -- HARD-WON LESSONS

### Build Verification
- Always verify binary UUID changed after code edits before debugging crashes.
  If UUID is identical across crash logs, DerivedData is stale.
  Clean build + simulator erase required.

### watchOS Constraints
- watchOS TabView(.verticalPage) + NavigationStack = crash. Never nest.
- watchOS Info.plist requires UIApplicationSceneManifest for SwiftUI apps.
- Apple Watch does NOT expose real-time beat-to-beat RR intervals to third-party apps.

### Trauma-Informed Design
- Never use red for biometric state indicators in trauma-informed apps.

---

## CHANGELOG

v12.0: Changelog extracted to CHANGELOG.md (installer 25K limit). Version bump from v11.12 — reflects three-gate workflow, enforcement gates, and /audit system added across v11.3–v11.12.

Full changelog: see CHANGELOG.md.
