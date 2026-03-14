<!-- version: 1.3 -->

Show all kit commands with descriptions.

| Command | Action |
|---------|--------|
| /begin | Start session — lock, brain, validation, status |
| /save | End session — summary, gates, handoff, commit, push, unlock |
| /snap | Mid-session — update brain files, no commit |
| /status | Live snapshot — phase, branch, issues, recommendation |
| /summary | Recap — features, issues, reconciliation |
| /recover | Emergency — dump state, snap, compact or clear |
| /brainstorm | Design session — invokes Architect + Specifier |
| /premerge | Pre-merge gate — Reviewer + Tester + checklist |
| /crew | Show agent roster and status |
| /spec | Invoke Specifier — produce PLAN.md for current task |
| /review | Invoke Reviewer — code review current branch |
| /docs | Invoke Documenter — sync brain files against codebase |
| /research | Invoke Architect — investigate a topic, structured analysis |
| /triage | Group open issues by area, recommend batch fix order |
| /test | Smart diff-based — maps changed files to screens, tests on 16-L + 17PM-L. Use after every feature. |
| /test [screen] | Targeted — tests one named screen on all 4 configs (16-L, 16-D, 17PM-L, 17PM-D) |
| /test-quick | Fast — unit tests only, mapped from changed files since last commit |
| /test-full | Everything — all screens, all 4 configs, VoiceOver, Dynamic Type. Overnight or pre-TestFlight. Zero prompts. |
| /feedback | Process FEEDBACK.md into GitHub issues (async channel) |
| /issues | Work hub — triage and fix issues |
| /testflight | Pull TestFlight feedback into FEEDBACK.md |
| /cleanup | Scan root for misplaced files, propose reorganization |
| /bridge | Slack bridge — read prompt file, execute, write summary |
| /clean | Quality loop — audit, review, independent review, test until zero issues |
| /ship | Pre-TestFlight — bump build, generate tester summary, approve |
| /update | Pull kit repo + install — no restart needed |
| /health | Architect audit mode — full codebase health check |
| /audit | Spec compliance — verify code against planning specs |
| /morning | Daily briefing — overnight results, feedback, priorities |
| /help | This reference |
| /help-terminal | Terminal shortcuts, git basics |

Built-in: /clear, /compact, /context, /mcp, /plugins

## Dev-Tools

Commands use scripts from ~/projects/claude-dev-tools/ when available.
If dev-tools is not installed, commands fall back to manual steps automatically.

| Category | Scripts | Used By |
|----------|---------|---------|
| session/ | preflight.sh, status.sh, checkpoint.sh, handoff.sh, lock.sh, morning.sh, recover.sh, crew.sh | /begin, /save, /snap, /status, /morning, /recover, /crew |
| gates/ | premerge-check.sh, audit-check.sh | /premerge, /audit |
| testing/ | smart-test-select.sh, test-report.sh | /test, /test-quick, /test-full |
| scanning/ | proactive-scan.sh, brain-health.sh, kit-validate.sh, health-scan.sh, cleanup.sh, convention-check.sh, duplicate-code.sh, import-graph.sh, schema-audit.sh, accessibility-audit.sh, decision-audit.sh | /begin, /health, /cleanup, /premerge, /save |
| git/ | repo-hygiene.sh, pr-summary.sh, commit-audit.sh | /premerge, /health |
| issues/ | list.sh, triage.sh, feedback.sh, dedup-check.sh, auto-close.sh | /issues, /triage, /feedback, /save, /ship |
| kit/ | update.sh, version-check.sh, build-bump.sh, pat-rotate.sh, simulator-manager.sh, cross-project.sh, testflight-preflight.sh | /update, /ship, /begin |
| refactoring/ | split-file.sh, string-audit.sh | Auto-correct (file 250+, string catalog) |
| audio-pipeline/ | voice-verify.sh, audit-audio.py, verify-text-bridge.py | /test-full, /ship |
| testflight-sync/ | sync-testflight-feedback.sh | /testflight |

Install: `git clone https://github.com/markaslett/claude-dev-tools.git ~/projects/claude-dev-tools`
