<!-- version: 2.1 -->

Read and execute a prompt from the bridge prompt file, writing structured summaries for the bot to post.

## Protocol — Bridge Summary File (v1)

Two files coordinate Claude Code ↔ bot communication:
- **Prompt file** (bot writes, Claude reads): `/tmp/claude-bridge-prompt-{session}.txt`
- **Summary file** (Claude writes, bot reads): `/tmp/claude-bridge-summary-{session}.jsonl`

The bot owns all Slack API calls. Claude Code never posts to Slack directly.

### JSONL Schema

Each line is a self-contained JSON object:
```json
{"protocol_version":1,"command":"/begin","status":"complete","emoji":":white_check_mark:","summary":"Branch main, 2 open issues","detail_lines":["Quick start (clean, same branch)"],"ts":"2026-03-13T10:30:00Z"}
```

Fields:
- `protocol_version`: always `1`
- `command`: the command name — slash-prefixed for commands (e.g., "/begin", "/save"), bare for hooks (e.g., "pre-merge", "pre-save")
- `status`: result state — common values: "complete", "warning", "error", "blocked". Commands may use domain-specific values: "round", "commit", "pass", "fail", "CLEAR", "BLOCKED", "HEALTHY", "NEEDS ATTENTION", "UNHEALTHY"
- `emoji`: Slack emoji for the status line
- `summary`: one-line summary (under 200 chars)
- `detail_lines`: array of additional detail strings (always present, may be empty `[]`)
- `ts`: ISO 8601 UTC timestamp

## Procedure

1. Determine session name:
   ```bash
   BRIDGE_SESSION=$(tmux display-message -p '#{session_name}' 2>/dev/null || hostname -s)
   ```

2. Read prompt from file:
   ```
   /tmp/claude-bridge-prompt-${BRIDGE_SESSION}.txt
   ```
   - File missing: STOP. Report: "No bridge prompt file found."
   - File empty: STOP. Report: "Bridge prompt file is empty."

3. Truncate summary file (clean slate for this invocation):
   ```bash
   > /tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl
   ```

4. Execute the prompt content. All normal session gates apply (/begin, complexity check, etc.).

5. Each command that runs during execution appends its own summary entry to the file.
   Commands check: if `BRIDGE_SESSION` is set, append. If not set (manual run), skip.

6. After all work completes, the bot reads the summary file and posts entries to the Slack thread.

**Principle:** If Mark reads ONLY the Slack thread, he should know exactly what happened without attaching to tmux.

## Rules

- Never auto-execute. Mark must say `/bridge` or the bot must send `/bridge`.
- Normal session gates still apply (/begin must have run, complexity check, etc.).
- Never include PATs, API keys, or sensitive data in summary entries.
- Summary file writes are best-effort — if a write fails, continue execution.
- The bot owns ALL Slack communication. Claude Code never calls Slack MCP for bridge purposes.

## Overnight Marker

Before executing the prompt, check if it is a long-running task. If so, write a marker
file so `restart-sessions.sh` skips this session during nightly restarts.

**Detection** — write `.overnight-running` in the project root if ANY of these match:
- Prompt contains keywords: "overnight", "regen", "test-full", "brainstorm", "full suite"
- Prompt was sent between 10 PM and 5 AM local time
- Prompt explicitly says to run unattended

**Write:**
```bash
echo "bridge $(date -u +%Y-%m-%dT%H:%M:%SZ)" > .overnight-running
```

**Delete** `.overnight-running` when execution completes (success or failure).
If Claude Code crashes, `restart-sessions.sh` auto-clears stale markers >24h.

False positives are harmless — the session just skips one nightly restart cycle.

## Fallback (prompt file not found)

If `/tmp/claude-bridge-prompt-${BRIDGE_SESSION}.txt` does not exist, fall back to
reading the prompt directly from the Slack channel (for manual `/bridge` invocations):

1. Read `SLACK_CHANNEL_ID` from CLAUDE-local.md. If not set: STOP with error.
2. Check if Slack MCP is available (attempt `slack_search_channels` or check MCP status).
   - If not available: report "No prompt file and no Slack MCP. Post prompt in Slack channel and let the bot trigger /bridge."
3. Read latest message from the channel using `slack_read_channel` (limit 1).
   - If not an actionable prompt: report "No actionable prompt found." STOP.
4. Read thread to check for existing read receipt (`:hourglass_flowing_sand:` reply).
   - If receipt exists: skip posting. Log "Read receipt already present."
   - If no receipt: post ":hourglass_flowing_sand: Executing..." to thread.
5. Execute the prompt. Write summary entries to `/tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl` as normal.
6. Post result to thread:
   - Success: ":white_check_mark: Done — [summary]"
   - Failure: ":x: Failed — [error]"
