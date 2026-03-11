<!-- version: 1.0 -->

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

**tmux basics:**
  tmux new -s name                  New named session
  tmux ls                           List sessions
  tmux attach -t name               Reattach to session
  tmux kill-session -t name         Kill a session

**tmux inside a session (prefix = Ctrl-b):**
  Ctrl-b d                          Detach (session keeps running)
  Ctrl-b c                          New window
  Ctrl-b n / p                      Next / previous window
  Ctrl-b %                          Split pane vertical
  Ctrl-b "                          Split pane horizontal
  Ctrl-b arrow                      Switch pane
  Ctrl-b z                          Zoom pane (toggle fullscreen)
  Ctrl-b [                          Scroll mode (q to exit)
  Ctrl-b x                          Kill current pane
