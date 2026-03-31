<!-- version: 3.0 -->

Read and execute a prompt from the bridge prompt file.

## How It Works

The bot writes a "processing" entry to JSONL at send time. Claude executes the task, then writes
ONE summary entry + a done sentinel at the end. The bot's JSONL reader posts both to the Slack thread.

Two files coordinate Claude Code ↔ bot communication:
- **Prompt file** (bot writes, Claude reads): `/tmp/claude-bridge-prompt-{session}.txt`
- **Summary file** (bot + Claude write, bot reads): `/tmp/claude-bridge-summary-{session}.jsonl`

The bot owns all Slack API calls. Claude Code never posts to Slack directly.

## Procedure

1. Determine session name:
   ```bash
   BRIDGE_SESSION=$(tmux display-message -p '#{session_name}' 2>/dev/null || hostname -s)
   ```

2. Read prompt from file: `/tmp/claude-bridge-prompt-${BRIDGE_SESSION}.txt`
   - File missing: STOP. Report: "No bridge prompt file found."
   - File empty: STOP. Report: "Bridge prompt file is empty."

3. Execute the prompt content. All normal session gates apply (/begin, complexity check, etc.).

4. **LAST STEP — write summary + done.** After ALL work is finished, write exactly two lines:
   ```bash
   SUMMARY_FILE="/tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl"
   echo '{"type":"summary","description":"ONE LINE DESCRIBING WHAT YOU DID","commits":[],"files_changed":0,"ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> "$SUMMARY_FILE"
   echo '{"type":"done","ts":"'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"}' >> "$SUMMARY_FILE"
   ```
   Replace the description, commits array, and files_changed count with real values.
   Optional fields: `"tests":"pass/fail counts"`, `"decisions":["D123"]`.
   **This is the ONLY JSONL you write. The bot handles everything else.**
   Nothing runs after the done line. This MUST be the absolute final bash command.

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
5. Execute the prompt. Write summary + done to `/tmp/claude-bridge-summary-${BRIDGE_SESSION}.jsonl` as in step 4 above.
6. Post result to thread:
   - Success: ":white_check_mark: Done — [summary]"
   - Failure: ":x: Failed — [error]"
