#!/usr/bin/env bash
# PostToolUse-Hook (Edit|Write) für ssh-console-manager: Syntaxprüfung der geänderten Datei, nie blockierend.
# Stack: eine Python-Datei ohne .py-Endung (sshmgr), install.sh, Zsh-Completion.
set -u
INPUT=$(cat)
FILE=$(printf '%s' "$INPUT" | sed -n 's/.*"file_path":"\([^"]*\)".*/\1/p' | head -1)
[ -z "$FILE" ] && FILE=$(printf '%s' "$INPUT" | sed -n 's/.*"path":"\([^"]*\)".*/\1/p' | head -1)
[ -z "$FILE" ] || [ ! -f "$FILE" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
has() { command -v "$1" >/dev/null 2>&1; }
case "$FILE" in
  *.py|*/sshmgr)
    has ruff && { ruff format "$FILE" >/dev/null 2>&1; ruff check --fix "$FILE" >/dev/null 2>&1; }
    python3 -m py_compile "$FILE" 2>&1 | head -10 ;;
  *.sh)
    bash -n "$FILE" 2>&1 | head -10
    has shellcheck && shellcheck -S warning "$FILE" 2>&1 | head -20 ;;
  */_sshmgr)
    has zsh && zsh -n "$FILE" 2>&1 | head -5 ;;
esac
exit 0
