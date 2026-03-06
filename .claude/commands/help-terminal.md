Terminal shortcuts and basics for Claude Code.

**Launch options:**
  claude                    Normal session
  claude-test               Overnight (skip permissions)
  claude --resume            Resume last session

**Context management:**
  /compact                  Compress context (try first)
  /clear                    Clear context (always /snap first)
  /context                  Show context usage

**Git basics:**
  git pull                  Get latest changes
  git status                See what changed
  git log --oneline -5      Recent commits

**MCP troubleshooting:**
  claude mcp list           Check server status
  claude mcp remove [name]  Remove broken server
  claude mcp add ...        Re-add server (see getting-started)

**Simulators:**
  xcrun simctl list devices         List all simulators
  xcrun simctl shutdown all         Reset all simulators
  xcrun simctl boot [UDID]          Boot specific simulator
