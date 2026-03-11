<!-- version: 1.0 -->

Read and execute the latest prompt from the project's Slack channel, with read receipt and result posting.

## Primary (Slack MCP available)

1. Read `SLACK_CHANNEL_ID` from CLAUDE-local.md.
   - Not set: STOP. Report: "Slack bridge not configured. Add SLACK_CHANNEL_ID to CLAUDE-local.md."

2. Verify Slack MCP is connected (attempt `slack_search_channels` or check MCP status).
   - Not available: go to Fallback section.

3. Read latest message from the channel using `slack_read_channel` (limit 1).
   - If the message does not look like a prompt (e.g., just a status update or join notice): report "No actionable prompt found in channel." STOP.

4. Post read receipt in the message thread immediately:
   - Message: ":hourglass_flowing_sand: Executing..."
   - Use `thread_ts` of the prompt message.

5. Execute the prompt content. Do all normal work (complexity check, build, etc.).

6. Post result back to the same thread:
   - Success: ":white_check_mark: Done — [brief summary, under 500 chars]"
   - Failure: ":x: Failed — [error summary, under 500 chars]"
   - If full output exceeds 500 chars, summarize and note "Full output in Claude Code session."

## Rules

- Never auto-execute. Mark must say `/bridge` to trigger.
- Always post read receipt before executing.
- Always post result after executing.
- Keep Slack posts under 500 chars. Link to full output if longer.
- Never include PATs, API keys, or sensitive data in Slack messages.
- Normal session gates still apply (/begin must have run, complexity check, etc.).

## Fallback (Slack MCP not available)

Report: "Slack MCP not available. Read prompt manually or run: `claude mcp add --transport http slack https://mcp.slack.com/mcp --scope user`"
