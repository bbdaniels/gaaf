#!/usr/bin/env bash
# GAAF doctor — diagnose the install
set -uo pipefail

GAAF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$GAAF_ROOT"

bold()   { printf '\033[1m%s\033[0m\n' "$*"; }
green()  { printf '\033[32m  ✓ %s\033[0m\n' "$*"; }
red()    { printf '\033[31m  ✗ %s\033[0m\n' "$*"; FAIL=1; }
yellow() { printf '\033[33m  ! %s\033[0m\n' "$*"; }

FAIL=0
bold "GAAF doctor"
echo "Root: $GAAF_ROOT"
echo

bold "[binaries]"
for cmd in git node python3 pipx gemini gaaf-mcp; do
  if command -v "$cmd" >/dev/null 2>&1; then
    green "$cmd ($(command -v "$cmd"))"
  else
    red "$cmd not found"
  fi
done

command -v code >/dev/null 2>&1 && green "code (VSCode CLI)" || yellow "code (VSCode CLI) — optional"

echo
bold "[project files]"
for f in GEMINI.md .gemini/settings.json README.md install.sh install.ps1 \
         methodology/principles.md methodology/identification.md \
         methodology/replication.md methodology/citation-discipline.md \
         methodology/writing-style.md; do
  [ -f "$f" ] && green "$f" || red "$f missing"
done

echo
bold "[slash commands]"
CMD_COUNT=$(find .gemini/commands -name '*.toml' 2>/dev/null | wc -l | tr -d ' ')
[ "$CMD_COUNT" -ge 1 ] && green "$CMD_COUNT slash commands found" || red "no slash commands in .gemini/commands/"

echo
bold "[gemini auth]"
if command -v gemini >/dev/null 2>&1; then
  if gemini auth status 2>&1 | grep -qi 'signed in\|authenticated'; then
    green "gemini authenticated"
  else
    yellow "gemini not signed in — run: gemini auth login"
  fi
fi

echo
bold "[mcp server health]"
if command -v gaaf-mcp >/dev/null 2>&1; then
  if echo '{"jsonrpc":"2.0","method":"initialize","id":1,"params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"doctor","version":"0"}}}' \
     | timeout 3 gaaf-mcp 2>/dev/null | grep -q '"result"'; then
    green "gaaf-mcp responds to initialize"
  else
    yellow "gaaf-mcp did not respond — check 'pipx list'"
  fi
fi

echo
if [ "$FAIL" = 1 ]; then
  red "FAIL — see issues above"
  exit 1
fi
bold "OK"
