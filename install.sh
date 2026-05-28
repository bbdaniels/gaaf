#!/usr/bin/env bash
# GAAF installer — macOS and Linux
# Tools up VSCode + Gemini CLI + GAAF MCP server in one shot.
set -euo pipefail

GAAF_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$GAAF_ROOT"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }
red()   { printf '\033[31m%s\033[0m\n' "$*"; }

have() { command -v "$1" >/dev/null 2>&1; }

bold "==> GAAF install (macOS / Linux)"
echo "Project root: $GAAF_ROOT"
echo

# ------------------------------------------------------------ prerequisites
bold "[1/6] Checking prerequisites"

need_brew=0
for cmd in git node python3 pipx; do
  if have "$cmd"; then
    green "  ✓ $cmd ($(command -v "$cmd"))"
  else
    red   "  ✗ $cmd not found"
    need_brew=1
  fi
done

if [ "$need_brew" = 1 ]; then
  yellow "Missing prerequisites. On macOS install with Homebrew:"
  echo "  brew install git node python pipx"
  echo "  pipx ensurepath"
  echo "On Linux, use your package manager (apt, dnf, etc.)."
  exit 1
fi

NODE_MAJOR=$(node -p "process.versions.node.split('.')[0]")
if [ "$NODE_MAJOR" -lt 20 ]; then
  red "Node $NODE_MAJOR detected; Gemini CLI needs Node 20+."
  exit 1
fi
green "  ✓ Node $NODE_MAJOR"

PY_VER=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
green "  ✓ Python $PY_VER"

if ! have code; then
  yellow "  ! VSCode 'code' CLI not on PATH."
  echo "    Open VSCode → Cmd+Shift+P → 'Shell Command: Install code command in PATH'."
  echo "    Continuing — install will proceed but cannot register VSCode extensions."
fi

# ------------------------------------------------------------ Gemini CLI
bold "[2/6] Installing Gemini CLI"

if have gemini; then
  green "  ✓ gemini already installed ($(gemini --version 2>&1 | head -1))"
else
  npm i -g @google/gemini-cli
  green "  ✓ gemini installed"
fi

# ------------------------------------------------------------ VSCode extension
bold "[3/6] Installing VSCode extensions"

if have code; then
  code --install-extension google.geminicodeassist --force >/dev/null
  green "  ✓ Gemini Code Assist"
  code --install-extension ms-python.python --force >/dev/null || true
  code --install-extension reditorsupport.r --force >/dev/null || true
  code --install-extension james-yu.latex-workshop --force >/dev/null || true
  green "  ✓ recommended extensions (Python, R, LaTeX Workshop)"
else
  yellow "  ! Skipped (VSCode 'code' CLI not available)"
fi

# ------------------------------------------------------------ MCP server
bold "[4/6] Installing GAAF MCP server"

pipx install --force "$GAAF_ROOT/mcp-server"
green "  ✓ gaaf-mcp installed via pipx"

# ------------------------------------------------------------ Authenticate
bold "[5/6] Authenticating Gemini"
yellow "  Next step (manual): run 'gemini auth login' to sign in."
echo "  This opens a browser for Google OAuth. Free tier is enough for class use."

# ------------------------------------------------------------ Smoke test
bold "[6/6] Smoke tests"

if have gaaf-mcp; then
  green "  ✓ gaaf-mcp on PATH"
else
  yellow "  ! gaaf-mcp not yet on PATH — run 'pipx ensurepath' and restart shell"
fi

if [ -f "$GAAF_ROOT/.gemini/settings.json" ]; then
  green "  ✓ .gemini/settings.json present"
fi
if [ -f "$GAAF_ROOT/GEMINI.md" ]; then
  green "  ✓ GEMINI.md present"
fi

echo
bold "==> GAAF install complete"
echo
echo "Next steps:"
echo "  1. gemini auth login"
echo "  2. code ."
echo "  3. In a terminal inside VSCode: gemini"
echo "  4. Try: /help, then /discover \"my research question\""
echo
echo "Doctor check: ./scripts/doctor.sh"
