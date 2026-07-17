# agent-tab-title

Show the conversation name in the iTerm2 tab for Claude Code and Codex CLI, so
multiple agent sessions are easy to tell apart.

- **Name source**: whatever you set with `/rename` in the agent, falling back to
  the auto-generated title, then a short session id.
- **Target**: the tab title (OSC escape), one agent per tab.

## Codex

Codex's TUI owns the terminal title, so this is a native config setting, not a
hook. In `~/.codex/config.toml`, under the `[tui]` table:

```toml
[tui]
terminal_title = ["thread-title"]
```

`thread-title` is the `/rename` name. Use `["thread-id"]` instead if you want the
raw conversation id when a thread is un-named. Validate with `codex doctor`.
Applies on the next `codex` launch.

## Claude Code

Claude's native title must be off (otherwise it competes with the hook):

```json
// ~/.claude/settings.json -> env
"CLAUDE_CODE_DISABLE_TERMINAL_TITLE": "1"
```

Copy `claude_title.py` to `~/.config/agent-tab-title/claude_title.py`, then add
these hooks to `~/.claude/settings.json` (merge into the existing `hooks` object,
don't overwrite other hooks):

```json
"hooks": {
  "SessionStart": [
    { "hooks": [ { "type": "command", "command": "python3 ~/.config/agent-tab-title/claude_title.py" } ] }
  ],
  "UserPromptSubmit": [
    { "hooks": [ { "type": "command", "command": "python3 ~/.config/agent-tab-title/claude_title.py" } ] }
  ],
  "Stop": [
    { "hooks": [ { "type": "command", "command": "python3 ~/.config/agent-tab-title/claude_title.py" } ] }
  ]
}
```

Claude injects a `UserPromptSubmit` hook's stdout into the model context, so the
script writes the OSC sequence to `/dev/tty`, never stdout. It re-asserts the
title on session start, every prompt, and every stop. Hooks load at startup —
restart Claude after editing.

Note: Claude's hook `command` field doesn't expand `~` on every setup; use an
absolute path (`/Users/<you>/.config/agent-tab-title/claude_title.py`) if the
tilde form doesn't fire.

## Caveats

- A tab's title follows the **focused pane**. In a split, focusing a non-agent
  pane flips the tab to that shell's title until the agent acts again. Lock the
  scratch pane's title (profile → Title) or use iTerm2 per-pane title bars if
  that bothers you.
- iTerm2: "Terminal may set tab/window title" must be enabled (default on).
