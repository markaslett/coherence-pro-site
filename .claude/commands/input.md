<!-- version: 1.1 -->

Process INPUT.md into GitHub issues. Classify, deduplicate, file.

## Primary (dev-tools available)

Run: `bash ~/projects/claude-dev-tools/issues/feedback.sh --json`
Read JSON: items (text, potential_duplicate, suggested_label), total,
duplicates_found, new_items.

For each item: review script's suggestion. If potential_duplicate is set,
check if it's a true duplicate or a distinct issue. Create GitHub issues
for new_items with suggested labels. Archive processed entries from INPUT.md.

## Fallback (dev-tools missing)

Warn: "dev-tools not found at ~/projects/claude-dev-tools/ — running manually."
Load issues module: cat ~/projects/claude-dev-kit/modules/issues.md
Read INPUT.md. Classify each item. Create GitHub issues. Archive processed entries.
