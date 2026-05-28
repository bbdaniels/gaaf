# GAAF doctor (Windows)
$GaafRoot = (Resolve-Path (Join-Path (Split-Path -Parent $PSCommandPath) '..')).Path
Set-Location $GaafRoot

$fail = $false
function Green($m)  { Write-Host ("  v {0}" -f $m) -ForegroundColor Green }
function Red($m)    { Write-Host ("  x {0}" -f $m) -ForegroundColor Red;    $script:fail = $true }
function Yellow($m) { Write-Host ("  ! {0}" -f $m) -ForegroundColor Yellow }
function Have($c)   { return [bool](Get-Command $c -ErrorAction SilentlyContinue) }

Write-Host "GAAF doctor" -ForegroundColor White
Write-Host "Root: $GaafRoot"
Write-Host ""

Write-Host "[binaries]" -ForegroundColor White
foreach ($c in @('git','node','python','pipx','gemini','gaaf-mcp')) {
  if (Have $c) { Green ("{0} ({1})" -f $c, (Get-Command $c).Source) } else { Red "$c not found" }
}
if (Have 'code') { Green "code (VSCode CLI)" } else { Yellow "code (VSCode CLI) — optional" }

Write-Host ""
Write-Host "[project files]" -ForegroundColor White
foreach ($f in @(
  'GEMINI.md','.gemini\settings.json','README.md','install.sh','install.ps1',
  'methodology\principles.md','methodology\identification.md',
  'methodology\replication.md','methodology\citation-discipline.md',
  'methodology\writing-style.md'
)) {
  if (Test-Path $f) { Green $f } else { Red "$f missing" }
}

Write-Host ""
Write-Host "[slash commands]" -ForegroundColor White
$n = (Get-ChildItem -Path '.gemini\commands' -Filter *.toml -ErrorAction SilentlyContinue).Count
if ($n -ge 1) { Green "$n slash commands found" } else { Red "no slash commands in .gemini\commands\" }

Write-Host ""
if ($fail) { Write-Host "FAIL — see issues above" -ForegroundColor Red; exit 1 }
Write-Host "OK" -ForegroundColor White
