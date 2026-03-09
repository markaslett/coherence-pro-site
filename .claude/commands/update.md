Update the kit without stopping Claude Code. Pull latest kit repo
and run install.sh to deploy updated files to this project.

## Primary (dev-tools available)

Run: `bash ~/projects/dev-tools/kit/update.sh --json`
Read JSON: current_version, latest_version, update_available, updated, changes.

If updated: report "Kit updated: v[old] -> v[new]. Files changed: [list]."
Warn: "Run /compact to pick up new CLAUDE.md instructions."

If not updated and update_available == false: "Kit is current (v[version])."
If not updated and update failed: report error.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/dev-tools/ — running manually."

1. Check kit repo: `git -C ~/projects/claude-dev-kit status --porcelain`
   If uncommitted changes: warn and stop.
2. Pull: `cd ~/projects/claude-dev-kit && git pull`
3. Install: `bash ~/projects/claude-dev-kit/install.sh [this-project-path]`
4. Report "Kit files: N updated, N unchanged" from install.sh output.
5. Warn: "Kit updated. Run /compact to pick up new CLAUDE.md instructions."

If git pull fails: warn and stop.
If install.sh fails: warn with exit code and stop.
