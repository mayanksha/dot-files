#!/usr/bin/env python3
"""Set the iTerm2 tab title for a Claude Code session.

Reads the hook JSON on stdin, resolves a title (in priority order:
/rename name -> auto-generated title -> short session id), and writes an
OSC 0 title sequence to /dev/tty. Writing to /dev/tty (not stdout) matters:
Claude injects a UserPromptSubmit hook's stdout into the model context.
"""
import json
import sys

# Tag Claude tabs by setting a prefix, e.g. "claude " or "✳ ". Empty = name only.
PREFIX = ""
MAX_LEN = 64


def resolve_title(transcript_path):
    """Last custom-title (from /rename) wins; else last ai-title."""
    custom = ai = None
    try:
        with open(transcript_path, encoding="utf-8", errors="ignore") as fh:
            for line in fh:
                if "Title" not in line:
                    continue
                try:
                    obj = json.loads(line)
                except ValueError:
                    continue
                if obj.get("customTitle"):
                    custom = obj["customTitle"]
                if obj.get("aiTitle"):
                    ai = obj["aiTitle"]
    except OSError:
        pass
    return custom or ai


def main():
    try:
        data = json.load(sys.stdin)
    except ValueError:
        data = {}

    title = None
    transcript_path = data.get("transcript_path")
    if transcript_path:
        title = resolve_title(transcript_path)
    if not title:
        session_id = data.get("session_id", "")
        title = session_id.split("-")[0] if session_id else "claude"

    title = (PREFIX + title)[:MAX_LEN]
    try:
        with open("/dev/tty", "w") as tty:
            tty.write(f"\033]0;{title}\007")
    except OSError:
        pass


if __name__ == "__main__":
    main()
