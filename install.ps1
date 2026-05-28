# GAAF installer — Windows (PowerShell 7+)
# Tools up VSCode + Gemini CLI + GAAF MCP server in one shot.

$ErrorActionPreference = 'Stop'
$GaafRoot = (Resolve-Path (Split-Path -Parent $PSCommandPath)).Path
Set-Location $GaafRoot

function Write-Bold($msg)   { Write-Host $msg -ForegroundColor White }
function Write-Green($msg)  { Write-Host $msg -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host $msg -ForegroundColor Yellow }
function Write-Red($msg)    { Write-Host $msg -ForegroundColor Red }
function Have($cmd) { return [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }

Write-Bold "==> GAAF install (Windows)"
Write-Host "Project root: $GaafRoot"
Write-Host ""

# ---------------------------------------------------------- prerequisites
Write-Bold "[1/6] Checking prerequisites"

$missing = @()
foreach ($cmd in @('git','node','python','pipx')) {
  if (Have $cmd) {
    Write-Green ("  v {0} ({1})" -f $cmd, (Get-Command $cmd).Source)
  } else {
    Write-Red   ("  x {0} not found" -f $cmd)
    $missing += $cmd
  }
}

if ($missing.Count -gt 0) {
  Write-Yellow "Missing prerequisites. Install with winget:"
  Write-Host "  winget install --id Git.Git -e"
  Write-Host "  winget install --id OpenJS.NodeJS.LTS -e"
  Write-Host "  winget install --id Python.Python.3.12 -e"
  Write-Host "  python -m pip install --user pipx; python -m pipx ensurepath"
  exit 1
}

$nodeMajor = [int](node -p "process.versions.node.split('.')[0]")
if ($nodeMajor -lt 20) {
  Write-Red "Node $nodeMajor detected; Gemini CLI needs Node 20+."
  exit 1
}
Write-Green "  v Node $nodeMajor"

$pyVer = (python -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
Write-Green "  v Python $pyVer"

if (-not (Have 'code')) {
  Write-Yellow "  ! VSCode 'code' CLI not on PATH."
  Write-Host  "    Open VSCode -> Ctrl+Shift+P -> 'Shell Command: Install code command in PATH'."
}

# ---------------------------------------------------------- Gemini CLI
Write-Bold "[2/6] Installing Gemini CLI"
if (Have 'gemini') {
  Write-Green ("  v gemini already installed ({0})" -f (gemini --version | Select-Object -First 1))
} else {
  npm i -g '@google/gemini-cli'
  Write-Green "  v gemini installed"
}

# ---------------------------------------------------------- VSCode extension
Write-Bold "[3/6] Installing VSCode extensions"
if (Have 'code') {
  code --install-extension google.geminicodeassist --force | Out-Null
  Write-Green "  v Gemini Code Assist"
  code --install-extension ms-python.python --force | Out-Null
  code --install-extension reditorsupport.r --force | Out-Null
  code --install-extension james-yu.latex-workshop --force | Out-Null
  Write-Green "  v recommended extensions (Python, R, LaTeX Workshop)"
} else {
  Write-Yellow "  ! Skipped (VSCode 'code' CLI not available)"
}

# ---------------------------------------------------------- MCP server
Write-Bold "[4/6] Installing GAAF MCP server"
pipx install --force "$GaafRoot\mcp-server"
Write-Green "  v gaaf-mcp installed via pipx"

# ---------------------------------------------------------- Authenticate
Write-Bold "[5/6] Authenticating Gemini"
Write-Yellow "  Next step (manual): run 'gemini auth login' to sign in."

# ---------------------------------------------------------- Smoke test
Write-Bold "[6/6] Smoke tests"
if (Have 'gaaf-mcp') {
  Write-Green "  v gaaf-mcp on PATH"
} else {
  Write-Yellow "  ! gaaf-mcp not yet on PATH — run 'pipx ensurepath' and restart shell"
}
if (Test-Path "$GaafRoot\.gemini\settings.json") { Write-Green "  v .gemini\settings.json present" }
if (Test-Path "$GaafRoot\GEMINI.md")             { Write-Green "  v GEMINI.md present" }

Write-Host ""
Write-Bold "==> GAAF install complete"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. gemini auth login"
Write-Host "  2. code ."
Write-Host "  3. In a terminal inside VSCode: gemini"
Write-Host "  4. Try: /help, then /discover ""my research question"""
Write-Host ""
Write-Host "Doctor check: .\scripts\doctor.ps1"
