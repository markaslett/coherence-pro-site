Update the kit without stopping Claude Code. Pull latest kit repo
and run install.sh to deploy updated files to this project.

Steps:
1. Check kit repo for uncommitted changes (git -C ~/projects/claude-dev-kit status --porcelain)
2. Run: cd ~/projects/claude-dev-kit && git pull
3. Run: bash ~/projects/claude-dev-kit/install.sh [this-project-path]
   Smart install: only copies files that actually changed. Fast (<5s when few files differ).
4. Report the "Kit files: N updated, N unchanged" line from install.sh output
5. Warn: "Kit updated. Run /compact to pick up new CLAUDE.md instructions.
   Module and agent validation will re-run at next /begin."

If kit repo has uncommitted changes: warn and stop (user may have local edits).
If git pull fails (network, merge conflict): warn and stop.
If install.sh fails: warn with exit code and stop.
Do not auto-run /compact — let the user decide when.
